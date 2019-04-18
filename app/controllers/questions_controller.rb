class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  after_action :publish_question, only: %i[create]

  include Voted

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.build
    @comment = Comment.new
  end

  def new
    question.links.build
    @badge = question.build_badge
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
      head :forbidden
    end

    subscription
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy

      redirect_to questions_path, notice: 'Question was deleted.'
    else
      head :forbidden
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def subscription
    @subscription ||= question.subscriptions.find_by(user: current_user)
  end

  helper_method :question, :subscription

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: %i[name url id _destroy],
                                     badge_attributes: %i[name img])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
        'questions',
        ApplicationController.render(
            partial: 'questions/question',
            locals: { question: question }
        )
    )
  end
end
