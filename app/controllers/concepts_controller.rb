class ConceptsController < ApplicationController
  before_filter :check_manager, :except => [:index, :show]
  def index
    @concepts = Concept.all
  end

  def show
    @concept = Concept.find(params[:id])
  end

  def new
    @concept = Concept.new
    session[:last_concept_path] = request.env["HTTP_REFERER"] || concepts_url
  end

  def edit
    @concept = Concept.find(params[:id])
    session[:last_concept_path] = request.env["HTTP_REFERER"] || concepts_url
  end

  def create
    @concept = Concept.new(params[:concept])

    if @concept.save
      flash[:notice] = 'Concept was successfully created.'
      redirect_to session[:last_concept_path]
      clear_last_paths
    else
      render :action => "new"
    end
  end
  
  def update
    @concept = Concept.find(params[:id])

    if @concept.update_attributes(params[:concept])
      flash[:notice] = 'Concept was successfully updated.'
      redirect_to session[:last_concept_path]
      clear_last_paths
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
