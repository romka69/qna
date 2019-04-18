class NewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    service = NewAnswerToSubscribers.new(answer)
    service.send_answer
  end
end
