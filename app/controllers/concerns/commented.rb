module Commented
  extend ActiveSupport::Concern

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

    comment = @obj.comments.new(body: comment_params[:comment_body])
    comment.author = current_user

    if comment.save
      render json: comment
    else
      render json: comment.errors, status: :unprocessable_entity
    end
  end

  def make_vote(method)
    obj_votable

    return head :forbidden if current_user&.author_of?(@obj)

    if @obj.send(method, current_user)
      render json: { resourceName: @obj.class.name.downcase,
                     resourceId: @obj.id,
                     resourceScore: @obj.score_resource }
    else
      head :forbidden
    end
  end
end
