require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:author) }
  it { should belong_to(:question) }

  it { should have_many(:links).dependent(:destroy)}

  it { should validate_presence_of(:body) }

  it { should accept_nested_attributes_for :links }

  describe 'Change mark' do
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }
    let(:answer) { create(:answer, author: author, question: question)}
    let(:best_answer) { create(:answer, author: author, question: question, best: true) }

    it 'have many attached files' do
      expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end

    context "answer is best" do
      it "unmarks answer" do
        best_answer.change_mark

        expect(best_answer).to_not be_best
      end
    end

    context "answer isn't best" do
      it "marks answer as best" do
        answer.change_mark

        expect(answer).to be_best
      end
    end
  end
end
