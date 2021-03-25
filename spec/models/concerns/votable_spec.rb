require 'rails_helper'

describe 'votable' do
  with_model :WithVotable do
    table do |t|
      t.integer :rating, default: 0
    end

    model do
      include Votable
    end
  end

  let(:user) { create(:user) }
  let(:votable) { WithVotable.create! }

  it "subtracts 1 of subject's rating if vote's value is negative" do
    votable.do_vote(-1)

    expect(votable.rating).to eq -1
  end

  it "adds 1 to subject's rating if vote's value is positive" do
    votable.do_vote(1)

    expect(votable.rating).to eq 1
  end
end
