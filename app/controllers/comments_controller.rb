class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    if @comment.save
      flash.now[:success] = "commented!"
      redirect_to(:back)
    else
      flash[:danger] = "Comment can't be blank!"
      redirect_to(:back)
    # wait for

    end
  end

  def destroy
    @comment.destroy
    flash[:success] = "Comment deleted"
    redirect_to (:back)
  end

  private




  def comment_params
     params.require(:comment).permit(:content,:entry_id)
  end
  
  def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_to root_url if @comment.nil?
  end 
  
end
