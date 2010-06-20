class DimensionsController < ApplicationController
  before_filter :check_staff_role, :only => :delete
  
  def index
    @dimensions = Dimension.all :order => "name"
    @facts = Dimension.all :order => "name", :conditions => "valuable_type = 'Fact'"
    @opinions = Dimension.all :order => "name", :conditions => "valuable_type = 'Opinion'"
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
