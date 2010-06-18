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
  end

  # GET /entities/new
  # GET /entities/new.xml
  def new
    @entity = Entity.new
    @entity.price = 0
  end

  # GET /entities/1/edit
  def edit
    @entity = Entity.find(params[:id])
    @entity.price = FactValue.get_value(Fact.find_by_name('Price'), @entity)
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
      flash[:notice] = 'Menu Item was successfully created.'
      redirect_to(@entity)
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
      fv = FactValue.get_value(Fact.find_by_name('Price'), @entity)
      fv.value = @entity.price
      fv.save!
      flash[:notice] = 'Menu Item was successfully updated.'
      redirect_to(@entity)
    else
      flash[:error] = 'Could not update Menu Item'
      render :action => "edit"
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
