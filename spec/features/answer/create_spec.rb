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

    scenario 'creates the answer', js: true do
      fill_in 'answer[body]', with: 'text text text'
      click_on 'Create'

      expect(page).to have_content 'text text text'
    end

    scenario 'creates the answer with errors', js: true do
      click_on 'Create'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'creates an answer with attached file', js: true do
      fill_in 'answer[body]', with: 'text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to create the answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Create'
  end
end