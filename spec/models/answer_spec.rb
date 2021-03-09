require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:author) }
  it { should belong_to(:question) }

  it { should validate_presence_of(:body) }

  describe 'Change mark' do
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }
    let(:answer) { create(:answer, author: author, question: question)}
    let(:best_answer) { create(:answer, author: author, question: question, best: true) }

    context "answer is best" do
      it "unmarks answer" do
        best_answer.change_mark

        expect(best_answer.best).to be_falsey
      end
    end

    context "answer isn't best" do
      it "marks answer as best" do
        answer.change_mark

        expect(answer.best).to be_truthy
      end
    end
  end
end
