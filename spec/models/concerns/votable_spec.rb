require 'rails_helper'

describe 'votable' do
  with_model :WithVotable do
    table do |t|
      t.integer :rating, default: 0
    end

    model do
      include Votable
      has_many :votes, dependent: :destroy, as: :votable
    end
  end

  let(:user) { create(:user) }
  let(:votable) { WithVotable.create! }
  let(:vote_for) { create(:vote, value: "for", votable: votable, user: user) }
  let(:vote_against) { create(:vote, value: "against", votable: votable, user: user) }

  context "cancel option is 'true'" do
    it "subtracts 1 of subject's rating and destroys vote if vote's value is 'for'" do
      user.votes.push(vote_for)
      votable.votes.push(vote_for)

      votable.do_vote('for', user, true)

      expect(votable.rating).to eq -1
      expect(votable.votes.count).to eq 0
    end

    it "adds 1 to subject's rating and destroys vote if vote's value is 'against'" do
      user.votes.push(vote_against)
      votable.votes.push(vote_against)

      votable.do_vote('against', user, true)

      expect(votable.rating).to eq 1
      expect(votable.votes.count).to eq 0
    end
  end

  context "cancel option is 'false'" do
    it "adds 1 to subject's rating and create vote if vote's value is 'for'" do
      votable.do_vote('for', user)

      expect(votable.rating).to eq 1
      expect(votable.votes.count).to eq 1
    end

    it "subtracts 1 of subject's rating and create vote if vote's value is 'negative'" do
      votable.do_vote('against', user)

      expect(votable.rating).to eq -1
      expect(votable.votes.count).to eq 1
    end
  end
end
