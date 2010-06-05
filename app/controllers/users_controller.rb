class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    @users = User.all
    @title = "User list"
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    @title = @user.first_name + " " + @user.last_name
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    @title = "Sign up"
  end

  # GET /users/1/edit
  def edit
    if params[:id] != "current"
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    @title = "Edit profile"
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @title = "Sign up"

    if @user.save
      flash[:notice] = 'Sign up successful.'
      redirect_to root_url
    else
      render :action => "new"
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    if params[:id] != "current"
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Profile updated successfully.'
      redirect_to(@user)
    else
      render :action => "edit"
    end

  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_url
  end
end
