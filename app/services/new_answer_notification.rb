class NewAnswerNotification
  def send_answer(answer)
    answer.question.subscriptions.find_each(batch_size: 500) do |subscription|
      NewAnswerNotificationMailer.answer(subscription, answer).deliver_later
    end
  end
end
