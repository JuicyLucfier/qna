class NewAnswerNotificationMailer < ApplicationMailer
  def answer(subscription, answer)
    @answer = answer
    @user = subscription.user

    mail to: @user.email, subject: "New answer!"
  end
end
