class SubscriptionsController < ApplicationController
  expose :question, -> { Question.find(params[:question_id]) }
  expose :subscription

  def new
    subscription.build_user
  end

  def create
    authorize! :create, Subscription
    @question = question
    @comment = Comment.new
    question.subscriptions.create(user: current_user)
  end

  def destroy
    authorize! :destroy, subscription
    subscription.destroy

    redirect_to question_path(subscription.question)
  end
end
