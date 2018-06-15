class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :logged_in? , except: [:login]

  private

  def logged_in?
    if session[:user_id].blank?
    	flash[:error] = "You must be logged in access the section"
    	redirect_to login_path
    else
    	@current_user ||= User.find(session[:user_id]) if session[:user_id]
    end	
  end

end