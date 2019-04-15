# Preview all emails at http://localhost:3000/rails/mailers/new_answer
class NewAnswerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/new_answer/new_answer
  def new_answer
    NewAnswerMailer.new_answer
  end

end
