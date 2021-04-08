require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:service) { double('NewAnswerNotification') }
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }

  before do
    allow(NewAnswerNotification).to receive(:new).and_return(service)
  end

  it 'calls NewAnswerNotification#send_answer' do
    expect(service).to receive(:send_answer).with(answer)
    NewAnswerNotificationJob.perform_now(answer)
  end
end
