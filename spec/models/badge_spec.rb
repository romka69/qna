require 'rails_helper'

RSpec.describe Badge, type: :model do
  it { should belong_to :question }
  it { should belong_to(:user).optional }

  it 'have one attached img' do
    expect(Badge.new.img).to be_an_instance_of(ActiveStorage::Attached::One)
  end

  it { should validate_presence_of :name }

  describe 'Badge' do
    let(:user) { create :user }
    let(:question) { create :question, author: user }
    let(:badge) { create :badge, question: question }
    let(:answer) { create :answer, author: user, question: question }

    it 'take to user' do
      badge.set_user(answer.author)
      badge.reload

      expect(badge.user).to eq answer.author
    end
  end
end
