class ConceptsController < ApplicationController
  before_filter :check_manager, :except => [:index, :show]
  def index
    redirect_to concept_path(Concept.find_by_name 'Mains')
  end

  def show
    @concept = Concept.find(params[:id])
    unless params[:belief]
      user = nil
    else
      user = current_user if params[:belief] == "Mine"
    end
    
    if params[:sort_by] and params[:sort_by] == "Ratings"
      @entities = @concept.sorted_entities user
    else
      @entities = @concept.entities
    end
    
    @selected_sort_order = params[:sort_by]
    @selected_belief = params[:belief]
    
    @selected_sort_order = "Alphabetical" unless params[:sort_by]
    @selected_belief = "Global" unless params[:belief]
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

    redirect_to :back
  end
end
