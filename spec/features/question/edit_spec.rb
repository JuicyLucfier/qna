require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user' do

    scenario 'edits his question', js: true do
      sign_in author
      visit question_path(question)

      click_on 'Edit question'

      fill_in 'Title', with: 'edited question'
      fill_in 'question[body]', with: 'edited text'

      click_on 'Save question'

      within '.question' do
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question'
        expect(page).to have_content 'edited text'
      end
    end

    scenario 'edits his question with errors', js: true do
      sign_in author
      visit question_path(question)

      click_on 'Edit question'
      click_on 'Save'

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to_not have_content 'edited question'
      expect(page).to_not have_content 'edited text'
    end

    scenario "tries to edit other user's question", js: true do
      sign_in user
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'Edit question'
      end
    end

    scenario 'edits the question with attached files', js: true do
      sign_in author
      visit question_path(question)

      click_on 'Edit question'

      fill_in 'Title', with: 'edited question'
      fill_in 'question[body]', with: 'edited text'

      attach_file 'question_files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Save question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end
end