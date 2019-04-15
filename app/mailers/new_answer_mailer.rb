class NewAnswerMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_digest_mailer.digest.subject
  #
  def new_answer(answer)
    @answer = answer

    mail to: answer.question.author.email,
         subject: "New answer in your question."
  end
end
