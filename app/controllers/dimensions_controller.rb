class DimensionsController < ApplicationController
  before_filter :check_staff_role, :only => :delete
  
  def index
    @fact_dimensions = Dimension.fact_dimensions
    @opinion_dimensions = Dimension.opinion_dimensions
  end
  
  
  
  def edit
    @dimension = Dimension.find(params[:id])
    if @dimension.valuable_type == "Opinion"
      @opinion = @dimension.valuable
      render 'opinions/edit'
    else
      @fact = @dimension.valuable
      render 'facts/edit'
    end
  end
    
  def destroy
    @dimension = Dimension.find(params[:id])
    @dimension.destroy

    redirect_to dimensions_url
  end
end
