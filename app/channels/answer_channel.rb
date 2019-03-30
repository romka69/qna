class AnswerChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "answers-#{data['question_id']}"
  end
end
