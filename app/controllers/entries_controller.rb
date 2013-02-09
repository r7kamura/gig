class EntriesController < ApplicationController
  before_filter :require_login, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :require_user
  before_filter :require_entry, :only => [:show, :edit, :update, :destroy]

  def new
    @entry = current_user.build_entry
    render :edit
  end

  def create
    @entry = current_user.build_entry(params[:entry])
    if @entry.save
      redirect_to user_entry_path(current_user, @entry)
    else
      render :edit
    end
  end

  def update
    if @entry.name == params[:entry][:name]
      current_user.destroy_entry(@entry.filename)
    end

    entry = current_user.build_entry(params[:entry])
    if entry.save
      redirect_to user_entry_path(current_user, @entry)
    else
      render :edit
    end
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
