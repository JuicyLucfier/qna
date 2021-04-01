require 'rails_helper'

feature 'User can create the comment', %q{
  In order to send the comment for any question or answer
  As an authenticated user
  I'd like to be able to create the comment
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'creates the comment', js: true do
      fill_in 'comment[body]', with: 'text text text'
      click_on 'Comment'

      expect(page).to have_content 'text text text'
    end

    scenario 'creates the comment with errors', js: true do
      click_on 'Comment'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to create the comment' do
    visit question_path(question)

    expect(page).to_not have_link 'Create'
  end
end