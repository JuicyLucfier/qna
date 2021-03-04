require 'rails_helper'

feature 'User can watch questions', %q{
  In order to see questions from a community
  As user
  I'd like to be able to watch questions
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user)}

  scenario 'User watches questions' do
    visit questions_path

    expect(page).to have_content question.title
  end
end