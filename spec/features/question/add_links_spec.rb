require 'rails_helper'

feature 'Author can add links to question', %q{
  In order to provide additional info to my question
  An an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, author: author) }
  given(:answer) { create(:answer, question: question, author: author) }
  given(:gist_url) { 'https://gist.github.com/JuicyLucfier/6e61db1d65bec40f2df5fab504d74bb5'}
  given(:url) { 'http://google.ru' }

  describe 'Authenticated author' do
    context 'adds link' do
      scenario 'when creates question', js: true do
        sign_in(author)
        visit questions_path

        click_on 'Ask question'

        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'

        fill_in 'Link name', with: 'My link'
        fill_in 'Url', with: url

        click_on 'Ask'

        expect(page).to have_link 'My link', href: url
      end

      scenario 'when edits question', js: true do
        sign_in(author)
        visit question_path(question)

        within '.question' do
          click_on 'Edit question'

          fill_in 'Title', with: 'edited question'

          click_on 'add link'

          fill_in 'Link name', with: 'My gist'
          fill_in 'Url', with: url

          click_on 'Save question'

          expect(page).to have_link 'My gist', href: url
          expect(page).to_not have_content question.title
          expect(page).to have_content 'edited question'
        end
      end

      scenario 'when creates question with errors', js: true do
        sign_in(author)
        visit questions_path

        click_on 'Ask question'

        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: url

        click_on 'Ask'

        expect(page).to have_content "Body can't be blank"
        expect(page).to_not have_link 'My gist', href: url
      end

      scenario 'when edits question with errors', js: true do
        sign_in(author)
        visit question_path(question)

        within '.question' do
          click_on 'Edit question'

          fill_in 'Title', with: ''

          click_on 'add link'

          fill_in 'Link name', with: 'My gist'
          fill_in 'Url', with: url

          click_on 'Save'

          expect(page).to have_content question.title
          expect(page).to_not have_link 'My gist', href: url
          expect(page).to have_content "Title can't be blank"
        end
      end
    end

    context 'adds gist link' do
      scenario 'when creates question', js: true do
        sign_in(author)
        visit questions_path

        click_on 'Ask question'

        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'

        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url

        click_on 'Ask'

        expect(page).to have_link 'delete link'
      end

      scenario 'when edits question', js: true do
        sign_in(author)
        visit question_path(question)

        within '.question' do
          click_on 'Edit question'

          fill_in 'Title', with: 'edited question'

          click_on 'add link'

          fill_in 'Link name', with: 'My gist'
          fill_in 'Url', with: gist_url

          click_on 'Save question'

          expect(page).to have_link 'delete link'
          expect(page).to_not have_content question.title
          expect(page).to have_content 'edited question'
        end
      end

      scenario 'when creates question with errors', js: true do
        sign_in(author)
        visit questions_path

        click_on 'Ask question'

        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url

        click_on 'Ask'

        expect(page).to have_content "Body can't be blank"
        expect(page).to_not have_link 'delete link'
      end

      scenario 'when edits question with errors', js: true do
        sign_in(author)
        visit question_path(question)

        within '.question' do
          click_on 'Edit question'

          fill_in 'Title', with: ''

          click_on 'add link'

          fill_in 'Link name', with: 'My gist'
          fill_in 'Url', with: gist_url

          click_on 'Save'

          expect(page).to have_content question.title
          expect(page).to_not have_link 'delete link'
          expect(page).to have_content "Title can't be blank"
        end
      end
    end

    scenario "can't add links to other user's question", js: true do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Edit question'
    end
  end

  describe 'Unauthenticated user' do
    scenario "can't add any link to question", js: true do
      visit question_path(question)

      expect(page).to_not have_link 'Edit question'
      expect(page).to_not have_link 'add link'
    end
  end

end