class NewAnswerNotificationMailer < ApplicationMailer
  def answer(answer, user)
    @answer = answer

    mail to: user.email, subject: "New answer!"
  end
end
