require 'rails_helper'

RSpec.describe NewAnswerToSubscribers do
  let(:users) { create_list :user, 3 }
  let(:user) { create :user }
  let(:question) { create :question, author: user }
  let(:answer) { create :answer, question: question, author: user }
  subject { NewAnswerToSubscribers.new(answer) }

  before do
    users.each do |u|
      answer.question.subscriptions.create(user: user)
    end

    users.push(question.author)
  end

  it 'send mail to users' do
    users.each { |user| expect(NewAnswerMailer).to receive(:new_answer).with(user, answer).and_call_original }

    subject.send_answer
  end
end
