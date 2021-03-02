class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]

  expose :answers, ->{ question.answers }
  expose :answer
  expose :question, -> { Question.find(params[:question_id]) }

  def create
    answer.question = question
    answer.author = current_user

    if answer.save
      redirect_to question, notice: 'Your answer successfully created!'
    else
      render 'questions/show'
    end
  end

  def destroy
    answer.destroy

    redirect_to question_path(answer.question), notice: 'Your answer successfully deleted!'
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

end
