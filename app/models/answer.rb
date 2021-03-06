class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :author, class_name: 'User'
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  def set_the_best
    self.transaction do
      question.answers.update_all(best: false )
      update!(best: true)
      question.badge&.update!(user: author)
    end
  end

  after_create :send_new_answer_in_question

  private

  def send_new_answer_in_question
    NewAnswerJob.perform_later(self)
  end
end
