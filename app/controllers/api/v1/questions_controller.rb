class Api::V1::QuestionsController < Api::V1::BaseController
  expose :question

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    @question = Question.find(params[:id])
    render json: @question
  end

  def create
    question.author = current_resource_owner

    if question.save
      render json: question
    else
      render json: question.errors, status: :unprocessable_entity
    end
  end

  def update
    if question.update(question_params)
      render json: question
    else
      render json: question.errors, status: :unprocessable_entity
    end
  end

  def destroy
    question.destroy
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, badge_attributes: [:title, :image], links_attributes: [:name, :url])
  end
end
