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
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    if current_user&.author_of?(answer)
      answer.destroy

      redirect_to answer.question, notice: 'Your answer successfully deleted!'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

end
