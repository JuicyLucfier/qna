require 'rails_helper'

RSpec.describe NewAnswerNotification do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }

  before { question.subscribers.push(create_list(:user, 3)) }

  it "sends notification about new answer to question's subscribers" do
    question.subscribers { |user| expect(NewAnswerNotificationMailer).to receive(:answer).with(answer, user).and_call_original }
    subject.send_answer(answer)
  end
end
