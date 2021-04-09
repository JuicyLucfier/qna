require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:author) }

  it { should have_one(:badge).dependent(:destroy) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :badge}

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#all_created_last_day' do
    let(:user) { create(:user) }

    context 'questions created last day' do
      let!(:questions) { create_list(:question, 3, author: user) }

      it 'returns these questions' do
        expect(Question.all_created_last_day).to match_array(questions)
      end
    end

    context 'questions created not last day' do
      let!(:questions) { create_list(:question, 3, created_at: Time.now - 999999, author: user) }

      it 'returns empty array' do
        expect(Question.all_created_last_day).to match_array([])
      end
    end
  end
end
