class DimensionsController < ApplicationController
  before_filter :check_staff_role, :only => :delete
  
  def index
    @fact_dimensions = Dimension.fact_dimensions
    @opinion_dimensions = Dimension.opinion_dimensions
  end
  
  
  
  def edit
    @dimension = Dimension.find(params[:id])
    if @dimension.valuable_type == "Opinion"
      # If there's an fact with the same name, do not allow this opinion to be edited
      if Dimension.find_by_name_and_valuable_type @dimension.name, 'Fact'
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
