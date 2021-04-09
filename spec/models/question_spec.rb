require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:author) }

  it { should have_one(:badge).dependent(:destroy) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscribers).through(:user_subscriptions) }
  it { should have_many(:user_subscriptions).dependent(:destroy) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :badge}

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#created_last_day?' do
    context 'calculates if object was created at least a day before' do
      let(:author) { create(:user) }
      let!(:question) { create(:question, author: author) }

      it 'returns true if it is' do
        question.created_at = Time.now - 1

        expect(question.created_last_day?).to be_truthy
      end

      it 'returns false if it is not' do
        question.created_at = Time.now - 999999

        expect(question.created_last_day?).to be_falsey
      end
    end
  end
end
