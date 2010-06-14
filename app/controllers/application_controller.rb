# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  helper_method :current_user, :role?
  
  def check_administrator
    unless role? 'administrator'
      flash[:notice] = "You do not have permission to do that"
      redirect_to root_path
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
  
end
