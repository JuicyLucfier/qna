require 'rails_helper'

feature 'User can delete his attachments', %q{
  In order to not show my attachments anymore
  As an authenticated user
  I'd like to be able to delete attachments
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, author: author) }
  given(:answer) { create(:answer, question: question, author: author) }

  describe 'Authenticated author' do
    scenario 'deletes the attachment' do
      question.files.attach(io: File.open(Rails.root.join("spec", "rails_helper.rb")), filename: 'rails_helper.rb',
                            content_type: 'file/rb')
      sign_in(answer.author)
      visit question_path(answer.question)

      click_on 'Delete file'

      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario "can't delete not his attachments" do
      sign_in(user)
      visit question_path(answer.question)

      expect(page).to_not have_link 'Delete file'
    end
  end

  scenario "Unauthenticated user can't delete any attachment" do
    visit question_path(answer.question)

    expect(page).to_not have_link 'Delete file'
  end

end