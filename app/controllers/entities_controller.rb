class EntitiesController < ApplicationController
  before_filter :check_manager, :except => [:show]
  # GET /entities
  # GET /entities.xml
  def index
    @entities = Entity.all
  end

  # GET /entities/1
  # GET /entities/1.xml
  def show
    @entity = Entity.find(params[:id])
    @ordinal_fact_values = @entity.fact_values.reject {|elem| elem.fact.dimension.bool? }
    @boolean_fact_values = @entity.fact_values.reject {|elem| !elem.fact.dimension.bool? }
  end

  # GET /entities/new
  # GET /entities/new.xml
  def new
    @entity = Entity.new
    #@entity.price = 0
  end

  # GET /entities/1/edit
  def edit
    @entity = Entity.find(params[:id])
    @entity.price = FactValue.get_value(Fact.find_by_name('Price'), @entity).value
  end

  # POST /entities
  # POST /entities.xml
  def create
    @entity = Entity.new(params[:entity])
    val = FactValue.create(:value => @entity.price)
    val.fact = Fact.find_by_name('Price')
    val.entity = @entity
    val.save
    
    if @entity.save
      flash[:notice] = 'Menu Item was successfully created. Please update as necessary.'
      render :edit
    else
      flash[:error] = 'Could not create the Menu Item'
      render :action => "new"
    end
    
  end

  # PUT /entities/1
  # PUT /entities/1.xml
  def update
    @entity = Entity.find(params[:id])
    
    if @entity.update_attributes(params[:entity])
    
      # Deal with price fact first
      price = FactValue.get_value(Fact.find_by_name('Price'), @entity)
      price.value = @entity.price
      price.save
      
      @entity.concept.fact_dimensions.each do |dim|
      
        next if dim.name == 'Price' # Guard against altering price fact
        
        # Get what value the user entered for this dimension
        # :dims could be null if everything is left empty.
        if params[:dims]
          entry = params[:dims][dim.id.to_s]
        else
          entry = nil
        end
        
        # Get a fact value associated with this dimension
        fv = FactValue.find_by_fact_id_and_entity_id dim.valuable, @entity
        
        # Three situations (4th doesn't really have to be handled)
        # 1 - Entry but no FV: Create FV
        # 2 - FV but no entry: Delete FV
        # 3 - FV and entry: Change value
        # 4 - No FV and no entry: Do nothing
        we_have_fv = false
        if fv
          if !entry or entry.blank?
            fv.destroy
          else
            we_have_fv = true   
          end
        elsif entry and !entry.blank?
          fv = FactValue.create
          we_have_fv = true
        end
        
        if we_have_fv
          fv.value = entry
          fv.fact = dim.valuable
          fv.entity = @entity
          fv.save       
        end
      end
      
      flash[:notice] = 'Menu Item was successfully updated.'
      redirect_to(@entity)
    else
      flash[:error] = 'Could not update Menu Item'
      render :edit
    end
  end

  # DELETE /entities/1
  # DELETE /entities/1.xml
  def destroy
    @entity = Entity.find(params[:id])
    @entity.destroy

    redirect_to(entities_url)
  end
end
