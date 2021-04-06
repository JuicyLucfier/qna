class Api::V1::QuestionsController < Api::V1::BaseController
  expose :question
  expose :questions, -> { Question.all }

  def index
    render json: questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: question, serializer: QuestionSerializer
  end

  def create
    authorize! :create, Question
    question.author = current_resource_owner

    if question.save
      render json: question, serializer: QuestionSerializer
    else
      render json: question.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, question

    if question.update(question_params)
      render json: question, serializer: QuestionSerializer
    else
      render json: question.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, question
    question.destroy
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
