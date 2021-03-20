class AnswersController < ApplicationController
  before_action :authenticate_user!

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
      answer.author.badges.push(@question.badge) if @question.badge.present? && answer.best?
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :_destroy])
  end
end
