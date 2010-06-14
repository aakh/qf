class DimensionsController < ApplicationController
  def index
    @dimensions = Dimension.all
  end

  def show
    @dimensions = Dimension.find(params[:id])
  end

  def new
    @dimension = Dimension.new
  end

  def edit
    @dimension = Dimension.find(params[:id])
  end

  def create
    @dimension = Dimension.new(params[:dimension])

    if @dimension.save
      flash[:notice] = 'Dimension was successfully created.'
      redirect_to(@dimension)
    else
      render :action => "new"
    end
  end
  
  def update
    @dimension = Dimension.find(params[:id])

    respond_to do |format|
    if @dimension.update_attributes(params[:dimension])
      flash[:notice] = 'Dimension was successfully updated.'
      redirect_to(@dimension)
    else
      render :action => "edit"
    end
  end

  def destroy
    @dimension = Dimension.find(params[:id])
    @dimension.destroy

    redirect_to(dimensions_url)
  end
end
