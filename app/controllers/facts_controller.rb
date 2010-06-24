class FactsController < ApplicationController
  before_filter :check_logged_in
  before_filter :check_staff
  
  def new
    @fact = Fact.new
    @fact.build_dimension
    session[:last_dimension_path] = request.env["HTTP_REFERER"] || dimensions_url
  end

  def create    
    @fact = Fact.new(params[:fact])
    if @fact.save
      flash[:notice] = 'Fact was successfully created.'
      redirect_to session[:last_dimension_path]
      clear_last_paths
    else
      render :new
    end
  end
  
  def update
    @fact = Fact.find(params[:id])

    if @fact.update_attributes params[:fact]
      flash[:notice] = 'Fact was updated created.'
      redirect_to session[:last_dimension_page]
      clear_last_paths
    else
      render 'edit'
    end
  end
    
  def destroy
    @fact = Fact.find(params[:id])
    @fact.destroy

    redirect_to :back
  end
end
