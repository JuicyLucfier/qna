class Api::V1::AnswersController < Api::V1::BaseController
  expose :question, -> { Question.find(params[:question_id]) }
  expose :answer

  def show
    render json: answer
  end

  def create
    @answer = question.answers.create(answer_params)
    @answer.author = current_resource_owner

    if @answer.save
      render json: @answer
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  def update
    if answer.update(answer_params)
      render json: answer
    else
      render json: answer.errors, status: :unprocessable_entity
    end
  end

  def destroy
    answer.destroy
  end

  private

  def answer_params
    params.require(:answer).permit(:body, links_attributes: [:name, :url, :_destroy])
  end
end
