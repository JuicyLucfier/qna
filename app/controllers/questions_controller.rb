class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, ->{ Question.all }
  expose :question
  expose :answer, ->{ question.answers.new }

  def create
    question.author = current_user

    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def destroy
    question.destroy

    redirect_to questions_path, notice: 'Question successfully deleted!'
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
