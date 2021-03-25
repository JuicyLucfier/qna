require 'rails_helper'

feature 'user can vote for and against question', %q{
  In order to encourage best question
  As an authenticated user
  I'd like to be able to vote for and against question
} do

  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }

  scenario 'Unauthenticated user can not vote for and against question', js: true do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Vote for'
      expect(page).to_not have_link 'Vote against'
    end
  end

  scenario 'Author of question can not vote for and against his question', js: true do
    sign_in(author)
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Vote for'
      expect(page).to_not have_link 'Vote against'
    end
  end

  scenario "User votes for other user's question", js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      click_on 'Vote for'

      expect(page).to have_link 'Voted for'
    end
  end

  scenario "User votes against other user's question", js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      click_on 'Vote against'

      expect(page).to have_link 'Voted against'
    end
  end

  scenario "User cancels his vote", js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      click_on 'Vote for'
      click_on 'Voted for'

      expect(page).to have_link 'Vote against'
      expect(page).to have_link 'Vote for'
    end
  end
end
