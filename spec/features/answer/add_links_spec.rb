require 'rails_helper'

feature 'Author can add links to answer', %q{
  In order to provide additional info to my answer
  An an answer's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, author: author)}
  given!(:answer) { create(:answer, question: question, author: author) }
  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c'}

  describe 'Authenticated author' do
    scenario 'adds link when creates answer', js: true do
      sign_in(author)
      visit question_path(question)

      click_on 'add link'

      fill_in 'Your answer', with: 'text text text'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Create'

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
      end
    end

    scenario 'adds link when edits answer', js: true do
      sign_in(author)
      visit question_path(question)

      click_on 'Edit answer'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'

        click_on 'add link'
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url

        click_on 'Save'

        expect(page).to have_link 'My gist', href: gist_url
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'adds link when creates answer with errors', js: true do
      sign_in(author)
      visit question_path(question)

      click_on 'add link'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Create'

      expect(page).to have_content "Body can't be blank"
      expect(page).to_not have_link 'My gist', href: gist_url
    end

    scenario 'adds link when edits answer with errors', js: true do
      sign_in(author)
      visit question_path(question)

      within '.answers' do
        click_on 'Edit answer'

        fill_in 'Your answer', with: ''

        click_on 'add link'

        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url

        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to_not have_link 'My gist', href: gist_url
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario "can't add links to other user's question", js: true do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Edit answer'
    end
  end

  describe 'Unauthenticated user' do
    scenario "can't add any link to answer", js: true do
      visit question_path(question)

      expect(page).to_not have_link 'Edit answer'
      expect(page).to_not have_link 'add link'
    end
  end

end