require 'rails_helper'

feature 'User can watch question and answers', %q{
  In order to see questions from a community
  As user
  I'd like to be able to watch question with answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, author: user, question: question)}

  background { visit question_path(question) }

  scenario 'User sees questions' do
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'User sees answers' do
    expect(page).to have_content answer.body
  end
end