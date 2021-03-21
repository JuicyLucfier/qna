require 'rails_helper'

feature 'User can delete his links', %q{
  In order to not show my links anymore
  As an authenticated user
  I'd like to be able to delete links
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, author: author) }
  given(:answer) { create(:answer, question: question, author: author) }

  describe 'Authenticated author' do
    background do
      answer.links.create(url: 'http://github.com', name: 'github')
    end

    scenario 'deletes the link' do
      sign_in(answer.author)
      visit question_path(answer.question)

      click_on 'delete'

      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario "can't delete not his link" do
      sign_in(user)
      visit question_path(answer.question)

      expect(page).to_not have_link 'delete'
    end
  end

  scenario "Unauthenticated user can't delete any link" do
    visit question_path(answer.question)

    expect(page).to_not have_link 'delete'
  end

end