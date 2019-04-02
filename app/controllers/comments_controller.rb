class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: %i[create]

  def create
    @comment = commentable.comments.new(body: comment_params[:comment_body])
    @comment.author = current_user

    if @comment.save
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private

  def commentable
    return Question.find(params[:question_id]) if params[:question_id]

    Answer.find(params[:answer_id]) if params[:answer_id]
  end

  def comment_params
    params.require(:comment).permit(:comment_body)
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
        "comments-#{@comment.commentable_id}", { comment: @comment }
    )
  end
end
