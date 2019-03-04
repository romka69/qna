require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).with_foreign_key('author_id').dependent(:nullify) }
  it { should have_many(:answers).with_foreign_key('author_id').dependent(:nullify) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let!(:user1) { create :user }
  let!(:user2) { create :user }
  let!(:question) { create :question, author: user1 }

  describe 'User#author_of?' do
    it 'yes' do
      expect(user1).to be_author_of(question)
    end

    it 'no' do
      expect(user2).to_not be_author_of(question)
    end
  end
end
