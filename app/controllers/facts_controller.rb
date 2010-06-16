class FactsController < ApplicationController
  before_filter :check_logged_in
  before_filter :check_staff_role, :only => :delete
  
  def new
    @fact = Fact.new
    @fact.build_dimension
  end

  def create    
    @fact = Fact.new(params[:fact])

    if @fact.save
      flash[:notice] = 'Fact was successfully created.'
      redirect_to dimensions_path
    else
      render :new
    end
  end
  
  def update
    @fact = Fact.find(params[:id])

    if @fact.update_attributes params[:fact]
      flash[:notice] = 'Fact was updated created.'
      redirect_to dimensions_path
    else
      render :edit
    end
  end
    
  def destroy
    @fact = Fact.find(params[:id])
    @fact.destroy

    redirect_to dimensions_url
  end
end
