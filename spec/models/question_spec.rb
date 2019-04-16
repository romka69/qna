require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribed).through(:subscriptions) }

  it { should have_one(:badge).dependent(:destroy) }

  it { should belong_to :author }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :badge }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'reputation' do
    let(:user) { create :user }
    let(:question) { build :question, author: user }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end

  it_behaves_like 'votable' do
    let(:user_model) { create :user }
    let(:model) { create :question, author: user }
  end

  it_behaves_like 'commentable' do
    let(:user_model) { create :user }
    let(:model) { create :comment, author: user }
  end
end
