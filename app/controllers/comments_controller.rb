class CommentsController < ApplicationController
  before_action :authenticate_user!

  after_action :publish_comment, only: %i[create]

  authorize_resource

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
    klass = [Question, Answer].detect{ |c| params["#{c.name.underscore}_id"] }
    klass.find(params["#{klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:comment_body)
  end

  def room_id
    commentable.is_a?(Question) ? commentable.id : commentable.question.id
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
        "comments-#{room_id}", { comment: @comment }
    )
  end
end
