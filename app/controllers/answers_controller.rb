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
      flash[:notice] = 'Answer was updated.'
    else
      head 403
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      flash[:notice] = 'Answer was deleted.'
    else
      head 403
    end
  end

  def pick_the_best
    if current_user.author_of?(answer.question)
      answer.set_the_best
      @question = answer.question
      flash[:notice] = 'Answer was picked.'
    else
      head 403
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answer.new
  end

  def question
    @question = Question.find(params[:question_id])
  end

  helper_method :answer

  def answer_params
    params.require(:answer).permit(:body)
  end
end
