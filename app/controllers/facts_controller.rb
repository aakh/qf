class FactsController < ApplicationController
  before_filter :check_logged_in
  before_filter :check_staff
  
  def new
    @fact = Fact.new
    @fact.build_dimension
    @fact.dimension.created_by = current_user.id
    session[:last_dimension_path] = request.env["HTTP_REFERER"] || dimensions_url
  end

  def create    
    @fact = Fact.new(params[:fact])
    @fact.dimension.op_name = params[:fact][:dimension_attributes][:name]
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
    @fact.dimension.op_name = @fact.dimension.name

    if @fact.update_attributes params[:fact]
      flash[:notice] = 'Fact was updated successfully.'
      redirect_to session[:last_dimension_path]
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
