require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy)  }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
end

describe 'Check authorship' do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:question) { create(:question, author: author) }

    it 'User is author' do
      expect(author).to be_author_of(question)
    end

    it 'User is not author' do
      expect(user).to_not be_author_of(question)
    end
end
