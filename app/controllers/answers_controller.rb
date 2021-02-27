class AnswersController < ApplicationController
  before_action :find_question, only: %i[new create]
  expose :answers, ->{ @question.answers }
  expose :answer

  def create
    answer = answers.new(answer_params)

    if answer.save
      redirect_to answer
    else
      render :new
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
