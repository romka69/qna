class AnswersController < ApplicationController
  before_action :authenticate_user!

  after_action :publish_answer, only: %i[create]

  include Voted

  authorize_resource

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
      head :forbidden
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      flash[:notice] = 'Answer was deleted.'
    else
      head :forbidden
    end
  end

  def pick_the_best
    if current_user.author_of?(answer.question)
      answer.set_the_best
      @question = answer.question
      flash[:notice] = 'Answer was picked.'
    else
      head :forbidden
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : question.answer.new
  end

  def question
    @question = Question.find(params[:question_id])
  end

  helper_method :answer

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url id _destroy])
  end

  def publish_answer
    return if @answer.errors.any?

    files = []
    answer.files.each do |file|
      files << { id: file.id, url: url_for(file), name: file.filename.to_s }
    end

    links = []
    answer.links.each do |link|
      hash = { id: link.id, name: link.name, url: link.url }
      hash[:gist] = link.gist(link.url) if link.gist_url?
      links << hash
    end

    ActionCable.server.broadcast(
        "answers-#{@answer.question_id}", { answer: @answer, links: links, files: files }
    )
  end
end
