class EntitiesController < ApplicationController
  before_filter :check_manager, :except => [:show, :rate, :index]
  before_filter :check_logged_in, :except => [:show, :index]
  # GET /entities
  # GET /entities.xml
  def index
    @entities = Entity.all(:include => [{:concept => :dimensions}]).select do |e|
      e.num_dims_used = 0;
      if e.rated_yet?
        n, d = e.get_distance_from_ideal
        e.distance = d
        e.num_dims_used = n
      end
      e.num_dims_used > 0
    end.sort
  end
  
  def rate
  
    @entity = Entity.find params[:id]
    
    unless params[:dims]
      flash[:error] = "You have to rate stuff first."
      redirect_to :back # no ratings to apply
    else
      params[:dims].each do |id, entry|
        dim = Dimension.find id
        r = Rating.find_or_create_by_opinion_id_and_entity_id_and_user_id dim.valuable, @entity, current_user
        cr = CurrentRating.find_by_entity_id_and_opinion_id @entity, dim.valuable
        
        if r.value #if this user is rating again then we have a current_rating for this dim/entity
          cr.total_rating -= r.value
          cr.num_ratings -= 1
        end
        
        r.value = entry.to_i
        r.opinion = dim.valuable
        r.entity = @entity
        r.user = current_user
        r.save 
        
        # Apply it to the current_ratings table
        unless cr
          cr = CurrentRating.create :entity => @entity, :opinion => dim.valuable
        end
        
        cr.total_rating += entry.to_i
        cr.num_ratings += 1
        cr.save
        
      end
      
      flash[:notice] = "Thank you for you rating."
      redirect_to :back
    end
  end

  # GET /entities/1
  # GET /entities/1.xml
  def show
    @entity = Entity.find(params[:id], :include => [:fact_values => {:fact => :dimension}])
    @ordinal_fact_values = @entity.fact_values.reject {|elem| elem.fact.dimension.bool? }
    @boolean_fact_values = @entity.fact_values.reject {|elem| !elem.fact.dimension.bool? }
    
    
    num_to_show = 5
    
    @num_ratings = Rating.entity_count(@entity)
    
    # Show the user his local "predicted" rating if the user has not rated this
    if current_user and @num_ratings > 0
      n, d = @entity.get_distance_from nil, current_user
      prating = (1 - (d / n)) * 10.0
      @local_rating = "<li>Predicted rating A: %.1f/10" % prating
      
      if current_user.has_rated? @entity
        prating = current_user.rating_for @entity
        @local_rating += "</li><li>You rated this: %.1f/10" % prating
      end  
      
      @local_rating << "</li>"
    end
    
    if @num_ratings > 0
      @percent_accurate = nil
      if current_user
        @total_dimensions = Dimension.count :conditions => {:valuable_type => 'Opinion', :enabled => true}
        @total_beliefs_set = Belief.count :joins => {:opinion => :dimension}, :conditions => {:user_id => current_user.id, :dimensions => {:enabled => true}}
        @percent_accurate = Integer((Float(@total_beliefs_set) / Float(@total_dimensions)) * 100)
      end
      
      @similar_entities = Entity.all(:include => {:concept => :dimensions}).select do |e|
        if @entity.rated_yet? && e.rated_yet?
          n, d = e.get_distance_from @entity, current_user
          e.distance = d
          e.num_dims_used = n
          n && e != @entity
        #else
         # false
        end
      end
      
      num_to_show = num_to_show < @similar_entities.length ? num_to_show : @similar_entities.length
      
      if num_to_show > 0
        @similar_entities = @similar_entities.sort[0...num_to_show]
      end
    end
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
      
      if params[:dims]
        params[:dims].each do |id, entry|
          dim = Dimension.find id
          fv = FactValue.find_or_create_by_fact_id_and_entity_id dim.valuable, @entity
          if entry.blank?
            fv.destroy
          else
            fv.value = entry
            fv.fact = dim.valuable
            fv.entity = @entity
            fv.save   
          end
        end
      end
      # @entity.concept.fact_dimensions.each do |dim|
      
        # next if dim.name == 'Price' # Guard against altering price fact
        
        # # Get what value the user entered for this dimension
        # # :dims could be null if everything is left empty.
        # if params[:dims]
          # entry = params[:dims][dim.id.to_s]
        # else
          # entry = nil
        # end
        
        # # Get a fact value associated with this dimension
        # fv = FactValue.find_by_fact_id_and_entity_id dim.valuable, @entity
        
        # # Three situations (4th doesn't really have to be handled)
        # # 1 - Entry but no FV: Create FV
        # # 2 - FV but no entry: Delete FV
        # # 3 - FV and entry: Change value
        # # 4 - No FV and no entry: Do nothing
        # we_have_fv = false
        # if fv
          # if !entry or entry.blank?
            # fv.destroy
          # else
            # we_have_fv = true   
          # end
        # elsif entry and !entry.blank?
          # fv = FactValue.create
          # we_have_fv = true
        # end
        
        # if we_have_fv
          # fv.value = entry
          # fv.fact = dim.valuable
          # fv.entity = @entity
          # fv.save       
        # end
      # end
      
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

    redirect_to :back
  end
end
