class EntitiesController < ApplicationController
  # GET /entities
  # GET /entities.xml
  def index
    @entities = Entity.all
  end

  # GET /entities/1
  # GET /entities/1.xml
  def show
    @entity = Entity.find(params[:id])
  end

  # GET /entities/new
  # GET /entities/new.xml
  def new
    @entity = Entity.new
  end

  # GET /entities/1/edit
  def edit
    @entity = Entity.find(params[:id])
  end

  # POST /entities
  # POST /entities.xml
  def create
    @entity = Entity.new(params[:entity])

    if @entity.save!
      flash[:notice] = 'Menu Item was successfully created.'
      redirect_to(@entity)
    else
      flash[:error] = 'Something went wrong.'
      render :action => "new"
    end
    
  end

  # PUT /entities/1
  # PUT /entities/1.xml
  def update
    @entity = Entity.find(params[:id])
    
    if @entity.update_attributes(params[:entity])
      flash[:notice] = 'Menu Item was successfully updated.'
      redirect_to(@entity)
    else
      flash[:error] = 'Something went wrong.'
      flash[:error] = params[:entity].inspect
      render :action => "edit"
    end
  end

  # DELETE /entities/1
  # DELETE /entities/1.xml
  def destroy
    @entity = Entity.find(params[:id])
    @entity.destroy

    redirect_to(entities_url)
  end
end
