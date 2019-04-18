require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:questions).with_foreign_key('author_id').dependent(:nullify) }
  it { should have_many(:answers).with_foreign_key('author_id').dependent(:nullify) }
  it { should have_many(:comments).with_foreign_key('author_id').dependent(:nullify) }
  it { should have_many(:badges).dependent(:nullify) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribed_questions).through(:subscriptions) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let!(:user1) { create :user }
  let!(:user2) { create :user }
  let!(:question) { create :question, author: user1 }

  describe '#author_of?' do
    it 'yes' do
      expect(user1).to be_author_of(question)
    end

    it 'no' do
      expect(user2).to_not be_author_of(question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create :user }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { double('FindForOauthService') }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '#subscribed_to?' do
    let(:user) { create :user }
    let(:question) { create :question, author: user }
    let(:user2) { create :user }

    it 'true' do
      expect(user).to be_subscribed_to(question)
    end

    it 'false' do
      expect(user2).to_not be_subscribed_to(question)
    end
  end
end
