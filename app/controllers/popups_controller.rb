class PopupsController < ApplicationController
  def edit_belief
    @dimension = Dimension.find(params[:id])
  end
  
  def rate
    @entity = Entity.find(params[:id])
  end
end
