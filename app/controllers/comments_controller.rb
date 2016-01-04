class CommentsController < ApplicationController
  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      redirect_to new_comment_path, flash: { notice: t('.success') }
    else
      render :new
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:user_email, :body)
  end
end
