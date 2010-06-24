class UserSessionsController < ApplicationController
  # GET /user_sessions/new
  # GET /user_sessions/new.xml
  def new
    @user_session = UserSession.new
    @title = "Sign in"
  end

  # POST /user_sessions
  # POST /user_sessions.xml
  def create
    @user_session = UserSession.new(params[:user_session])

    if @user_session.save
      flash[:notice] = 'Signed in successfully.'
      if(session[:last_check_path])
        redirect_to session[:last_check_path]
        clear_last_paths and return
      else
        redirect_to root_url
      end
    else
      render :action => "new"
    end
  end

  # DELETE /user_sessions/1
  # DELETE /user_sessions/1.xml
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = 'Logged out successfully'

    redirect_to root_url
  end
end
