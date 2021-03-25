require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:user_badges).dependent(:destroy) }
  it { should have_many(:badges).through(:user_badges) }
  it { should have_many(:votes).dependent(:destroy)}

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:question) { create(:question, author: author) }
  let(:vote) { create(:vote, value: "for", votable: question, user: user) }

  describe 'Check authorship' do
      it 'User is author' do
        expect(author).to be_author_of(question)
      end

      it 'User is not author' do
        expect(user).to_not be_author_of(question)
      end
  end

  describe 'Check that user voted' do
    it 'User voted' do
      user.votes.push(vote)
      question.votes.push(vote)

      expect(user.voted?(question)).to be_truthy
    end

    it 'User not voted' do
      expect(user.voted?(question)).to be_falsey
    end
  end

  describe "Search for user's vote that matches votable's vote" do
    it 'vote is found' do
      user.votes.push(vote)
      question.votes.push(vote)

      expect(user.vote(question)).to eq vote
    end

    it 'vote is not found' do
      expect(user.vote(question)).to_not eq vote
    end
  end
end
