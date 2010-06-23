class OpinionsController < ApplicationController
  before_filter :check_logged_in
  before_filter :check_staff_role, :only => :delete
  
  def new
    @opinion = Opinion.new
    @opinion.build_dimension 
  end

  def create    
  
    @opinion = Opinion.new(params[:opinion])
    if params[:opinion][:dimension_attributes][:name] =~ /\?\Z/
      flash[:error] = "Dimensions cannot be questions."
      render :new
    else
      if @opinion.save
        flash[:notice] = 'Opinion was successfully created.'
        redirect_to dimensions_path
      else
        render :new
      end
    end
  end
  
  def update
    @opinion = Opinion.find(params[:id])

    if @opinion.update_attributes params[:opinion]
      flash[:notice] = 'Opinion was updated created.'
      redirect_to session[:last_dimension_page] 
    else
      render 'edit'
    end
  end
    
  def destroy
    @opinion = Opinion.find(params[:id])
    @opinion.destroy

    redirect_to dimensions_url
  end
end
