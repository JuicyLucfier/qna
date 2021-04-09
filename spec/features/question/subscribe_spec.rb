require 'rails_helper'

feature 'Author can subscribe for question', %q{
  In order to get notifications about new answers
  As an authenticated user
  I'd like to be able to subscribe for question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario 'Unauthenticated user can not subscribe for question', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Subscribe'
  end

  describe 'Authenticated user' do
    scenario 'subscribes', js: true do
      sign_in(user)
      visit question_path(question)
      click_on 'Subscribe'

      expect(page).to have_link 'Unsubscribe'
    end
  end
end
