class LikesController < ApplicationController
  before_action :logged_in_user

  def create
    entry = Entry.find(params[:entry_id])
    current_user.like(entry)
    redirect_to(:back)
  end

  def destroy
    entry = Entry.find(params[:entry_id])
    current_user.unlike(entry)
    redirect_to(:back)
  end
end
