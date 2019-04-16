class NewAnswerToSubscribers
  def initialize(answer)
    @answer = answer
  end

  def send_answer
    @answer.question.subscribed.find_each(batch_size: 500) do |user|
      NewAnswerMailer.new_answer(user, @answer).deliver_later
    end
  end
end
