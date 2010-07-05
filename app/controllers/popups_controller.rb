class PopupsController < ApplicationController
  def one_belief
    @dimension = Dimension.find(params[:id])
  end
  
  def update_one_belief
    redirect_to :one_belief
  end
end
