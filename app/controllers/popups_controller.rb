class PopupsController < ApplicationController
  def edit_belief
    @dimension = Dimension.find(params[:id])
  end
end
