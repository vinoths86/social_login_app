class SessionsController < ApplicationController

  skip_before_action :logged_in?, only: [:create,:verify_login]

  def login
    render layout:false
  end

  def verify_login
    byebug
    user = User.where(login_params).first
    if user.present?
      reset_session
      session[:user_id] = user.id
      @current_user ||= user
      redirect_to root_path
    else
      flash[:error] = "Incorrect Username and Password"
      redirect_to login_path
    end
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to root_path
  end

  def destroy
    reset_session
    session[:user_id] = nil
    redirect_to login_path
  end

  private

  def login_params
    {
        email: params[:email],
        password: Digest::MD5.hexdigest(params[:password])
    }
  end

end