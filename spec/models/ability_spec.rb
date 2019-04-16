require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:user2) { create :user }
    let(:question) { create :question, author: user }
    let(:question2) { create :question, author: user2 }
    let(:answer) { create :answer, question: question, author: user }
    let(:answer2) { create :answer, question: question, author: user2 }
    let(:subscription) { create :subscription, question: question, user: user }
    let(:subscription2) { create :subscription, question: question, user: user2 }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Subscription }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, question2 }

    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, answer2 }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, question2 }

    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, answer2 }

    it { should be_able_to :destroy, subscription }
    it { should_not be_able_to :destroy, subscription2 }

    it { should be_able_to :destroy, ActiveStorage::Attachment }

    it { should be_able_to :destroy, create(:link, linkable: question) }
    it { should_not be_able_to :destroy, create(:link, linkable: question2) }

    it { should be_able_to :pick_the_best, answer }

    it { should be_able_to :vote_up, question2 }
    it { should be_able_to :vote_down, question2 }
    it { should_not be_able_to :vote_up, question }
    it { should_not be_able_to :vote_down, question }
  end
end