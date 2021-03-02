require 'rails_helper'

feature 'User can delete his question', %q{
  In order to not show my question anymore
  As an authenticated user
  I'd like to be able to delete question
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, author: author) }

    scenario 'Authenticated author deletes a question' do
      sign_in(author)
      visit question_path(question)
      click_on 'Delete'

      expect(page).to_not have_content question.title
      expect(page).to have_content "Question successfully deleted!"
    end

    scenario "Authenticated author can't delete not his questions" do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete'
    end

    scenario "Unauthenticated user can't delete any question" do
      visit question_path(question)
      expect(page).to_not have_link 'Delete'
    end
end