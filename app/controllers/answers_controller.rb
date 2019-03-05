class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
    flash[:notice] = 'Your answer successfully created.'
  end

  def update
    if current_user.author_of?(answer)
      answer.update(answer_params)
      question = answer.question
      flash[:notice] = 'Answer was updated.'
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      respond_to { |format| format.js }
      flash[:notice] = 'Answer was deleted.'
    else
      head 401
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answer.new
  end

  def question
    @question = Question.find(params[:question_id])
  end

  helper_method :answer #, :question

  def answer_params
    params.require(:answer).permit(:body)
  end
end
