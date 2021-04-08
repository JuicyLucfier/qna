class NewAnswerNotification
  def send_answer(answer)
    NewAnswerNotificationMailer.answer(answer).deliver_later
  end
end
