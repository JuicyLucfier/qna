class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.all_created_last_day

    mail to: user.email, subject: "Question digest"
  end
end
