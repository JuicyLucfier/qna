class NewAnswerNotification
  def send_answer(answer)
    answer.question.subscribers.find_each(batch_size: 500) do |user|
      NewAnswerNotificationMailer.answer(answer, user).deliver_later
    end
  end
end
