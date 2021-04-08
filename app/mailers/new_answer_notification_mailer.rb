class NewAnswerNotificationMailer < ApplicationMailer
  def answer(answer)
    @answer = answer

    mail to: answer.author.email, subject: "New answer!"
  end
end
