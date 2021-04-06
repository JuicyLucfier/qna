class Api::V1::AnswersController < Api::V1::BaseController
  expose :question, -> { Question.find(params[:question_id]) }
  expose :answer

  def index
    render json: question.answers, each_serializer: AnswersSerializer
  end

  def show
    render json: answer, serializer: AnswerSerializer
  end

  def create
    authorize! :create, Answer
    @answer = question.answers.create(answer_params)
    @answer.author = current_resource_owner

    if @answer.save
      render json: @answer, serializer: AnswerSerializer
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, answer
    if answer.update(answer_params)
      render json: answer, serializer: AnswerSerializer
    else
      render json: answer.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, answer
    answer.destroy
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
