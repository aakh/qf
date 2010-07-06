class DimensionsController < ApplicationController
  before_filter :check_staff, :only => :delete
  before_filter :check_logged_in
  
  def index
    @fact_dimensions = Dimension.fact_dimensions
    @opinion_dimensions = Dimension.opinion_dimensions
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
        render 'opinions/edit'
      end
    else
      @fact = @dimension.valuable
      render 'facts/edit'
    end
  end
    
  def destroy
    @dimension = Dimension.find(params[:id])
    @dimension.destroy

    redirect_to :back
  end
end
