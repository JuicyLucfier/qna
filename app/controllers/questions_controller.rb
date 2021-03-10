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

  def update
    if current_user&.author_of?(question)
      @question = load_question
      @question.update(question_params)
    end
  end

  def edit
    self.question = load_question
  end

  def show
    self.question = load_question
    @answer = Answer.new
  end

  def destroy
    if current_user&.author_of?(question)
      self.question = load_question
      question.destroy

      redirect_to questions_path, notice: 'Question successfully deleted!'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end

  def load_question
    Question.with_attached_files.find(params[:id])
  end
end
