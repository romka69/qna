module Commented
  extend ActiveSupport::Concern

  included do
    after_action :publish_comment, only: %i[create_comment]
  end

  def create_comment
    make_comment
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def obj_commentable
    @obj ||= model_klass.find(params[:id])
  end

  def comment_params
    params.require(params[:commentable].to_sym).permit(:comment_body)
  end

  def make_comment
    obj_commentable

    @comment = @obj.comments.new(body: comment_params[:comment_body])
    @comment.author = current_user

    if @comment.save
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
        "comments-#{@comment.commentable_id}", { comment: @comment }
    )
  end
end
