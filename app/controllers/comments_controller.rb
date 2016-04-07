class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    if @comment.save
      flash.now[:success] = "commented!"
      redirect_to(:back)
    else
      render text: 'dau xanh rau ma'
    # wait for

    end
  end

  def destroy
  end

  private




  def comment_params
     params.require(:comment).permit(:content,:entry_id)
  end
end
