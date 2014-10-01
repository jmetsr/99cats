class SessionsController < ApplicationController

  def create
    check_log_in
    user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )


    if user.nil?
      flash[:errors] = ["credentials were wrong"]
      render :new
    else
      user.set_session_token
      login!(user)
      redirect_to cats_url
    end
  end

  def new
    render :new unless check_log_in
  end

  def destroy
    current_user.reset_session_token
    session[:session_token] = nil
    redirect_to cats_url
  end

  private
  def check_log_in
    if !current_user.nil?
      redirect_to cats_url
    end
    return !!current_user
  end
end
