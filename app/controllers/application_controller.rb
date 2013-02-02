class ApplicationController < ActionController::Base
  protect_from_forgery

  NotFound = Class.new(StandardError)

  rescue_from ActiveRecord::RecordNotFound, NotFound, :with => :render_not_found

  helper_method :current_user, :logged_in?, :author

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = nil
  end

  def logged_in?
    !!current_user
  end

  def render_not_found
    render "public/404", :layout => false, :status => 404
  end

  def require_login
    redirect_to login_path unless logged_in?
  end
end
