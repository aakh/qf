class ConceptsController < ApplicationController
  def index
    @concepts = Concept.all
  end

  def show
    @concept = Concept.find(params[:id])
  end

  def new
    @concept = Concept.new
  end

  def edit
    @concept = Concept.find(params[:id])
  end

  def create
    @concept = Concept.new(params[:concept])

    if @concept.save
      flash[:notice] = 'Concept was successfully created.'
      redirect_to(@concept)
    else
      render :action => "new"
    end
  end
  
  def update
    @concept = Concept.find(params[:id])

    if @concept.update_attributes(params[:concept])
      flash[:notice] = 'Concept was successfully updated.'
      redirect_to(@concept)
    else
      render :action => "edit"
    end
  end

  def destroy
    @concept = Concept.find(params[:id])
    @concept.destroy

    redirect_to(concepts_url)
  end
end
