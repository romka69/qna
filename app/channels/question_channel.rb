class QuestionChannel < ApplicationCable::Channel
  def follow
    stream_from 'questions'
  end
end
