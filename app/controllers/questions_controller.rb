class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, ->{ Question.all }
  expose :question
  expose :answer, ->{ question.answers.new }

  def new
    question.links.new
  end

  def create
    question.author = current_user

    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if current_user&.author_of?(question)
      @question = question
      @question.update(question_params)
    end
  end

  def show
    self.question = Question.with_attached_files.find(params[:id])
    @answer = Answer.new
    @answer.links.new
  end

  def destroy
    if current_user&.author_of?(question)
      question.destroy

      redirect_to questions_path, notice: 'Question successfully deleted!'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url, :_destroy])
  end
end
