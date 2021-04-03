require 'rails_helper'

feature 'Author can add badge to question', %q{
  In order to appreciate users for best answers
  An an question's author
  I'd like to be able to add badge
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, author: author) }

  describe 'Authenticated author adds badge' do
    scenario 'when creates question', js: true do
      sign_in(author)
      visit questions_path

      click_on 'Ask question'

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Badge name', with: 'My badge'
      attach_file 'Image', "#{Rails.root}/spec/support/test.png"

      click_on 'Ask'

      expect(Question.last.badge.title).to eq 'My badge'
      expect(Question.last.badge.image.filename.to_s).to eq "test.png"
    end

    scenario 'when creates question with errors', js: true do
      sign_in(author)
      visit questions_path

      click_on 'Ask question'

      fill_in 'Badge name', with: 'My badge'
      attach_file 'Image', "#{Rails.root}/spec/support/test.png"

      click_on 'Ask'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated author tries to create question with attached badge' do
    visit questions_path

    expect(page).to_not have_link 'Ask question'
  end
end