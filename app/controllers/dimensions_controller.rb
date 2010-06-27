class DimensionsController < ApplicationController
  before_filter :check_staff, :only => :delete
  before_filter :check_logged_in
  
  def index
    @fact_dimensions = Dimension.fact_dimensions
    @opinion_dimensions = Dimension.opinion_dimensions
  end
  
  def edit
    @dimension = Dimension.find(params[:id])
    session[:last_dimension_path] = request.env["HTTP_REFERER"] || dimensions_url
    if @dimension.valuable_type == "Opinion"
      # If there's an fact with the same name, do not allow this opinion to be edited
      if Fact.find_by_name @dimension.name, 'Fact'
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
