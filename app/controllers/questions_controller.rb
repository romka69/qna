class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.build
  end

  def new
    question.links.build
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_user

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(question)
      question.update(question_params)
      flash[:notice] = 'Question was updated.'
    else
      head 403
    end
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy

      redirect_to questions_path, notice: 'Question was deleted.'
    else
      head 403
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url])
  end
end
