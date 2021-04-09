class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :set_comment

  after_action :publish_answer, only: [:create]

  expose :question, -> { Question.find(params[:question_id]) }
  expose :answer

  def create
    authorize! :create, Answer
    @answer = question.answers.create(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    authorize! :update, answer
    @answer = answer
    @answer.update(answer_params)
    @question = answer.question
  end

  def destroy
    authorize! :destroy, answer
    answer.destroy
    redirect_to answer.question, notice: 'Your answer successfully deleted!'
  end

  def best
    authorize! :best, answer
    @question = answer.question
    @answers = @question.answers
    answer.change_mark
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast("question_#{question.id}/answers", @answer)
  end

  def set_comment
    @comment = Comment.new
  end
end
