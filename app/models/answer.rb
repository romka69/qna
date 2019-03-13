class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_many_attached :files

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  def set_the_best
    self.transaction do
      question.answers.update_all(best: false )
      update!(best: true)
    end
  end
end
