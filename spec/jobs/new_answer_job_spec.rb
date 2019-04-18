require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:service) { double 'NewAnswerToSubscribers' }
  let(:user) { create :user }
  let(:question) { create :question, author: user }
  let(:answer) { create :answer, author: user, question: question }

  before do
    allow(NewAnswerToSubscribers).to receive(:new).with(answer).and_return(service)
  end

  it 'calls NewAnswerToSubscribers#send_answer' do
    expect(service).to receive(:send_answer)
    NewAnswerJob.perform_now(answer)
  end
end
