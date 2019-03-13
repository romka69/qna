require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :author }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  let(:user) { create :user }
  let!(:question) { create :question, author: user }
  let!(:answer) { create :answer, question: question, author: user }
  let!(:answer1) { create :answer, question: question, author: user }

  it '#set_the_best' do
    answer.set_the_best

    expect(answer).to be_best
  end

  it '#set_the_best only one' do
    answer.set_the_best

    expect(answer1).to_not be_best
  end

  it 'sort_by_best' do
    answer1.set_the_best

    expect(Answer.all.sort_by_best.first).to eq answer1
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
