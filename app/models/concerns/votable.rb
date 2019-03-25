module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  SCORES = { up: 1, down: -1 }.freeze

  def score_resource
    votes.sum(:score)
  end

  def vote_up(user)
    make_vote(user, :up)
  end

  def vote_down(user)
    make_vote(user, :down)
  end

  private

  def find_user(user)
    @voted_user = votes.find_by(user: user.id)
  end

  def can_revote?(option)
    if option == :up
      return true if @voted_user == -1
    elsif option == :down
      return true if @voted_user == 1
    end
  end

  def make_vote(user, option)
    find_user(user)
    return false if user.author_of?(self)

    return votes.create(user: user, score: SCORES[option]) unless @voted_user.present?

    @voted_user.update!(score: 0) if can_revote?(option)
  end
end
