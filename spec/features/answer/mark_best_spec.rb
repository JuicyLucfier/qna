require 'rails_helper'

feature 'Author can mark best answer', %q{
  In order to see best answer
  As an author of question
  I'd like to be able to mark answer as best
} do

  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, question: question, author: author) }

  scenario 'Unauthenticated user can not mark answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Mark as best'
  end

  describe 'Authenticated author' do

    scenario 'marks best answer', js: true do
      sign_in(author)
      visit question_path(question)
      click_on 'Mark as best'

      expect(page).to have_link 'Unmark'
    end

    scenario "tries to mark other user's question's answer", js: true do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Mark as best'
    end
  end
end