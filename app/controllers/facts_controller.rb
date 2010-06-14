class FactsController < ApplicationController

  def new
    @fact = Fact.new
    @fact.dimension = Dimension.new
  end

  def create    
    @fact = Fact.new(params[:fact])

    if @fact.save
      flash[:notice] = 'Fact was successfully created.'
      redirect_to(@fact)
    else
      render :action => "new"
    end
  end
  
end
