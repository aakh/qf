class FactsController < ApplicationController
  def index
    @facts = Fact.all
  end

  def show
    @facts = Fact.find(params[:id])
  end

  def new
    @fact = Fact.new
    @fact.dimension = Dimension.new
  end

  def edit
    @fact = Fact.find(params[:id])
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
  
  def update
    @fact = Fact.find(params[:id])

    if @fact.update_attributes(params[:fact])
      flash[:notice] = 'Fact was successfully updated.'
      redirect_to(@fact)
    else
      render :action => "edit"
    end
  end

  def destroy
    @fact = Fact.find(params[:id])
    @fact.destroy

    redirect_to(facts_url)
  end
end
