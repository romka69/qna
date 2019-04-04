class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  has_many :authorizations, dependent: :destroy
  has_many :answers, foreign_key: 'author_id', dependent: :nullify
  has_many :questions, foreign_key: 'author_id', dependent: :nullify
  has_many :comments, foreign_key: 'author_id', dependent: :nullify
  has_many :badges, dependent: :nullify
  has_many :votes, dependent: :destroy

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def author_of?(object)
    object.author_id == id
  end
end
