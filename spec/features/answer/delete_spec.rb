require 'rails_helper'

feature 'User can delete answer', %q{
  In order to delete your answer to a community
  As an author of answer
  I'd like to delete the answer
} do

  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, author: user1) }
  given!(:answer) { create(:answer, question: question, author: user1)}

  describe 'Authenticated user', js: true do
    scenario 'author del question' do
      sign_in(user1)
      visit questions_path
      click_on question.title
      click_on 'Delete answer'

      expect(page).to have_content 'Answer was deleted.'
      expect(page).to_not have_content answer.body
    end

    scenario 'not author del question' do
      sign_in(user2)
      visit questions_path
      click_on question.title

      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'Unauthenticated user del question' do
    visit questions_path
    click_on question.title

    expect(page).to_not have_link 'Delete answer'
  end
end
