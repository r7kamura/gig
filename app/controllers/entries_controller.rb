class EntriesController < ApplicationController
  before_filter :require_login, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :require_user
  before_filter :require_entry, :only => [:show, :edit, :update, :destroy]

  def new
    @entry = Entry.new(:nickname => current_user.nickname)
    render :edit
  end

  def create
    entry = current_user.create_entry(params[:entry])
    redirect_to user_entry_path(current_user, entry)
  end

  def update
    if @entry.name == params[:entry][:name]
      entry = current_user.update_entry(params[:entry])
    else
      current_user.destroy_entry(@entry.filename)
      entry = current_user.update_entry(params[:entry])
    end
    redirect_to user_entry_path(current_user, entry)
  end

  def destroy
    current_user.destroy_entry(@entry.filename)
    redirect_to @user
  end

  private

  def require_entry
    @entry = @user.entry(params[:id]) or raise NotFound
  end

  def require_user
    @user = User.find_by_nickname!(params[:user_id])
  end
end
