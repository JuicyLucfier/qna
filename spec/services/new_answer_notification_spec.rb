require 'rails_helper'

RSpec.describe NewAnswerNotification do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }
  let!(:subscription) { create(:subscription, question: question, user: create(:user)) }

  it "sends notification about new answer to question's subscribers" do
    question.subscriptions { |subscription| expect(NewAnswerNotificationMailer).to receive(:answer).with(answer, subscription).and_call_original }
    subject.send_answer(answer)
  end
end
