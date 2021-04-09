class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]

  after_action :publish_question, only: [:create]

  expose :questions, ->{ Question.all }
  expose :question
  expose :answer, ->{ question.answers.new }

  def new
    question.links.new
    question.build_badge
  end

  def create
    authorize! :create, Question
    question.author = current_user

    if question.save
      current_user.subscriptions.push(question)
      redirect_to question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    authorize! :update, question
    @question = question
    @comment = Comment.new
    @question.update(question_params)
  end

  def show
    self.question = Question.with_attached_files.find(params[:id])
    gon.question_id = question.id
    @answer = Answer.new
    @question = question
    @comment = Comment.new
    @answer.links.new
  end

  def destroy
    authorize! :destroy, question
    question.destroy

    redirect_to questions_path, notice: 'Question successfully deleted!'
  end

  def subscribe
    authorize! :subscribe, question
    @question = question
    @comment = Comment.new
    current_user.manage_subscription_of(question)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, badge_attributes: [:title, :image], files: [],
                                     links_attributes: [:name, :url])
  end

  def publish_question
    return if question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question_link',
        locals: { question: question }
      )
    )
  end
end
