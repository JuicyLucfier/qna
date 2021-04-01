class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :set_comment
  after_action :publish_answer, only: [:create]

  authorize_resource

  expose :question, -> { Question.find(params[:question_id]) }
  expose :answer

  def create
    @answer = question.answers.create(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    if current_user&.author_of?(answer)
      @answer = answer
      @answer.update(answer_params)
      @question = answer.question
    end
  end

  def destroy
    if current_user&.author_of?(answer)
      answer.destroy

      redirect_to answer.question, notice: 'Your answer successfully deleted!'
    end
  end

  def best
    if current_user&.author_of?(answer.question)
      @question = answer.question
      @answers = @question.answers
      answer.change_mark
    end
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
