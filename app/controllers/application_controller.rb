# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  helper_method :current_user, :role?
  
  def clear_last_paths(which = [:check, :dimension, :concept])
    which.each do |w|
      session["last_#{w}_path".intern] = nil
    end
  end
  
  def check_administrator
    unless role? 'administrator'
      flash[:notice] = "You do not have permission to do that."
      session[:last_check_path] = request.env["HTTP_REFERER"] || :back
      redirect_to login_path
    end
  end
  
  def check_manager
    unless role? 'manager'
      flash[:notice] = "You do not have permission to do that."
      session[:last_check_path] = request.env["HTTP_REFERER"] || :back
      redirect_to login_path
    end
  end
  
  def check_staff
    unless role? 'staff'
      flash[:notice] = "You do not have permission to do that."
      session[:last_check_path] = request.env["HTTP_REFERER"] || :back
      redirect_to login_path
    end
  end
  
  def check_logged_in
    unless current_user
      flash[:notice] = "You have to log in first."
      session[:last_check_path] = request.env["HTTP_REFERER"] || :back
      redirect_to login_path
    end
  end
  
  private
  def current_user_session
    return @current_user_session if defined? @current_user_session
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined? @current_user
    @current_user = current_user_session && current_user_session.record
  end
  
  def role?(r)
    current_user and current_user.has_role? r.capitalize
  end
  
  def check_role(name, msg)
  end
  
end
