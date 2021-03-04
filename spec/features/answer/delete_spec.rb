require 'rails_helper'

feature 'User can delete his answer', %q{
  In order to not show my answer anymore
  As an authenticated user
  I'd like to be able to delete answer
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, author: author) }
  given(:answer) { create(:answer, question: question, author: author)}

  scenario 'Authenticated author deletes an answer' do
    sign_in(answer.author)
    visit question_path(answer.question)
    click_on 'Delete answer'

    expect(page).to_not have_content answer.body
    expect(page).to have_content "Your answer successfully deleted!"
  end

  scenario "Authenticated author can't delete not his answers" do
    sign_in(user)
    visit question_path(answer.question)

    expect(page).to_not have_link 'Delete answer'
  end

  scenario "Unauthenticated user can't delete any answer" do
    visit question_path(answer.question)
    expect(page).to_not have_link 'Delete answer'
  end
end