require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { is_expected.to validate_url_of :url }
end

describe 'Check that url is a gist' do
  let(:author) { create(:user) }
  let(:question) { create(:question, author: author) }

  it 'Link is a gist' do
    question.links.create(url: 'https://gist.github.com/JuicyLucfier/6e61db1d65bec40f2df5fab504d74bb5', name: 'gist')

    expect(question.links.first).to be_gist
  end

  it 'Link is not a gist' do
    question.links.create(url: 'http://google.ru', name: 'google')

    expect(question.links.first).to_not be_gist
  end
end
