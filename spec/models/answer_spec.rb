require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should have_many(:votes).dependent(:destroy) }
  it { should belong_to :question }
  it { should belong_to :author }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  let(:user) { create :user }
  let!(:question) { create :question, author: user }
  let!(:answer) { create :answer, question: question, author: user }
  let!(:answer1) { create :answer, question: question, author: user }

  describe '#set_the_best' do
    context 'badge' do
      let!(:badge) { create :badge, question: question }

      it 'take to user badge' do
        answer.set_the_best

        expect(badge.user).to eq answer.author
      end
    end

    it 'best answer' do
      answer.set_the_best

      expect(answer).to be_best
    end

    it 'only one' do
      answer.set_the_best

      expect(answer1).to_not be_best
    end

    it 'sort_by_best' do
      answer1.set_the_best

      expect(Answer.all.sort_by_best.first).to eq answer1
    end
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'Email' do
    let(:user) { create :user }
    let(:question) { create :question, author: user }

    it 'send answer to author question when answer will be created' do
      expect(NewAnswerMailer).to receive(:new_answer).and_call_original
      create(:answer, question: question, author: user)
    end
  end


  it_behaves_like 'votable' do
    let(:model) { create :answer, question: question, author: user }
  end

  it_behaves_like 'commentable' do
    let(:model) { create :comment, author: user }
  end
end
