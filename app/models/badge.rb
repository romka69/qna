class Badge < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  has_one_attached :img

  validates :name, presence: true

  def set_user(user)
    update!(user: user)
  end
end
