class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(object)
    NewAnswerNotification.new.send_answer(object)
  end
end
