class DimensionsController < ApplicationController
  before_filter :check_staff, :only => :delete
  before_filter :check_logged_in
  before_filter :check_administrator, :only => :enable
  
  def index
    @fact_dimensions = Dimension.fact_dimensions
    @opinion_dimensions = Dimension.opinion_dimensions
  end
  
  def enable
    @dimension = Dimension.find(params[:id])
    @dimension.enabled = !@dimension.enabled?
    @dimension.save!
    
    if @dimension.valuable_type == 'Fact'
      vt = 'Opinion'
    else
      vt = 'Fact'
    end
    
    # Disable/Enable the corresponding fact/opinion if there is one
    @other = Dimension.find_by_name_and_valuable_type @dimension.name, vt
    if @other
      @other.enabled = @dimension.enabled
      @other.save!
    end
    
    flash[:notice] = (@dimension.enabled? ? "Enabled" : "Disabled") + " " + @dimension.name
    redirect_to :back
  end
  
  def show
    @dimension = Dimension.find(params[:id])
    @opinion = @dimension.valuable
    beliefs = Belief.find_by_opinion_id @dimension.valuable
    @num_who_care = @opinion.num_ideals
    if @opinion.num_weights > 0
      @weight = '%.1f' % (@opinion.total_weight / @opinion.num_weights)
    else
      @weight = "Not available..."
    end
    
    if @num_who_care > 0
      if @dimension.bool?
        @ideal = (@opinion.total_ideal / @opinion.num_ideals) > 0.5 ? "Mostly liked" : "Mostly disliked"
      else
        @ideal = '%.1f' % ((@opinion.total_ideal / @opinion.num_ideals) * 2)
      end
    else
      @ideal = "Not available..."
    end
  end
  
  def edit
    @dimension = Dimension.find(params[:id])
    
    
    session[:last_dimension_path] = request.env["HTTP_REFERER"] || dimensions_url
    if @dimension.valuable_type == "Opinion"
      # If there's a fact with the same name, do not allow this opinion to be edited
      if Fact.find_by_name @dimension.name
        flash[:error] = "Not allowed to edit that dimension"
        redirect_to :back
      else
        @opinion = @dimension.valuable
        @opinion.dimension.edited_by = current_user.id
        render 'opinions/edit'
      end
    else
      @fact = @dimension.valuable
      @fact.dimension.edited_by = current_user.id
      render 'facts/edit'
    end
  end
    
  def destroy
    @dimension = Dimension.find(params[:id])
    @dimension.destroy

    redirect_to :back
  end
end
