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
  given(:gist_url) { 'https://gist.github.com/JuicyLucfier/6e61db1d65bec40f2df5fab504d74bb5'}
  given(:url) { 'http://google.ru' }

  describe 'Authenticated author' do
    context 'adds link' do
      scenario 'when creates answer', js: true do
        sign_in(author)
        visit question_path(question)

        click_on 'add link'

        fill_in 'Your answer', with: 'text text text'

        fill_in 'Link name', with: 'My link'
        fill_in 'Url', with: url

        click_on 'Create'

        within '.answers' do
          expect(page).to have_link 'My link', href: url
        end
      end

      scenario 'when edits answer', js: true do
        sign_in(author)
        visit question_path(question)

        click_on 'Edit answer'

        within '.answers' do
          fill_in 'Your answer', with: 'edited answer'

          click_on 'add link'
          fill_in 'Link name', with: 'My link'
          fill_in 'Url', with: url

          click_on 'Save'

          expect(page).to have_link 'My link', href: url
          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
        end
      end

      scenario 'when creates answer with errors', js: true do
        sign_in(author)
        visit question_path(question)

        click_on 'add link'

        fill_in 'Link name', with: 'My link'
        fill_in 'Url', with: url

        click_on 'Create'

        expect(page).to have_content "Body can't be blank"
        expect(page).to_not have_link 'My link', href: url
      end

      scenario 'when edits answer with errors', js: true do
        sign_in(author)
        visit question_path(question)

        within '.answers' do
          click_on 'Edit answer'

          fill_in 'Your answer', with: ''

          click_on 'add link'

          fill_in 'Link name', with: 'My link'
          fill_in 'Url', with: url

          click_on 'Save'

          expect(page).to have_content answer.body
          expect(page).to_not have_link 'My link', href: url
        end
        expect(page).to have_content "Body can't be blank"
      end
    end

    context 'adds gist link' do
      scenario 'when creates answer', js: true do
        sign_in(author)
        visit question_path(question)

        click_on 'add link'

        fill_in 'Your answer', with: 'text text text'

        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url

        click_on 'Create'

        within '.answers' do
          expect(page).to have_link 'delete link'
        end
      end

      scenario 'when edits answer', js: true do
        sign_in(author)
        visit question_path(question)

        click_on 'Edit answer'

        within '.answers' do
          fill_in 'Your answer', with: 'edited answer'

          click_on 'add link'
          fill_in 'Link name', with: 'My gist'
          fill_in 'Url', with: gist_url

          click_on 'Save'

          expect(page).to have_link 'delete link'
          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
        end
      end

      scenario 'when creates answer with errors', js: true do
        sign_in(author)
        visit question_path(question)

        click_on 'add link'

        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url

        click_on 'Create'

        expect(page).to have_content "Body can't be blank"
        expect(page).to_not have_link 'delete link'
      end

      scenario 'when edits answer with errors', js: true do
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
          expect(page).to_not have_link 'delete link'
        end
        expect(page).to have_content "Body can't be blank"
      end
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