module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def score_resource
    votes.sum(:score)
  end

  def vote_up(user)
    if user_pass?(user, :up)
      @vote_user.update!(score: 0)
    elsif !@vote_user.present?
      votes.create(user: user, score: 1)
    end
  end

  def vote_down(user)
    if user_pass?(user, :down)
      @vote_user.update!(score: 0)
    elsif !@vote_user.present?
      votes.create(user: user, score: -1)
    end
  end

  private

  def find_user(user)
    @vote_user ||= votes.find_by(user: user.id)
  end

  def user_pass?(user, option)
    find_user(user)

    if option == :up
      return false if user.author_of?(self) || @vote_user.score > 0
    elsif option == :down
      return false if user.author_of?(self) || @vote_user.score < 0
    end
  end
end
