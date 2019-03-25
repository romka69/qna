module Voted
  extend ActiveSupport::Concern

  def vote_up
    make_vote(:vote_up)
  end

  def vote_down
    make_vote(:vote_down)
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def obj_votable
    @obj ||= model_klass.find(params[:id])
  end

  def make_vote(method)
    return :forbidden if current_user&.author_of?(obj_votable)

    if @obj.send(method, current_user)
      render json: obj.score_resource
    else
      head :forbidden
    end
  end
end
