require 'rails_helper'

RSpec.describe NewAnswerNotification do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }

  it "sends notification about new answer to question's author" do
    expect(NewAnswerNotificationMailer).to receive(:answer).with(answer).and_call_original
    subject.send_answer(answer)
  end
end
