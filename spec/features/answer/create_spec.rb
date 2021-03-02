require 'rails_helper'

feature 'User can create the answer', %q{
  In order to send the answer for any question
  As an authenticated user
  I'd like to be able to create the answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'creates the answer' do
      fill_in 'Body', with: 'text text text'
      click_on 'Create'

      expect(page).to have_content 'Your answer successfully created!'
      expect(page).to have_content 'text text text'
    end

    scenario 'creates the answer with errors' do
      click_on 'Create'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to create the answer' do
    visit question_path(question)
    click_on 'Create'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end