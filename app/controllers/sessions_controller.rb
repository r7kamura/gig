class SessionsController < ApplicationController
  def callback
    user = User.find_or_create_from_auth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to user
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  def failure
    redirect_to root_path
  end
end
