require 'rails_helper'

feature 'Author can unmark best answer', %q{
  In order to change best answer
  As an author of question
  I'd like to be able to unmark best answer
} do

  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, question: question, author: author, best: true) }

  scenario 'Unauthenticated user can not unmark answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Unmark'
  end

  describe 'Authenticated author' do

    scenario 'unmarks best answer', js: true do
      sign_in author
      visit question_path(question)

      click_on 'Unmark'

      expect(page).to have_link 'Mark as best'
    end

    scenario "tries to unmark other user's question's answer", js: true do
      sign_in user
      visit question_path(question)

      expect(page).to_not have_link 'Unmark'
    end
  end
end