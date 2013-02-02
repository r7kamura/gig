class UsersController < ApplicationController
  before_filter :require_user, :only => :show

  private

  def require_user
    @user = User.find_by_nickname!(params[:id])
  end
end
