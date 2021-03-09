require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, question: question, author: author) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end

  describe 'Authenticated user' do

    scenario 'edits his answer', js: true do
      sign_in(author)
      visit question_path(question)

      click_on 'Edit answer'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      sign_in(author)
      visit question_path(question)

      click_on 'Edit answer'

      within '.answers' do
        click_on 'Save'

        expect(page).to have_content answer.body
      end
    end

    scenario "tries to edit other user's answer", js: true do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Edit answer'
    end
  end
end