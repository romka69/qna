require 'rails_helper'

feature 'User can delete question', %q{
  In order to delete your question to a community
  As an author of question
  I'd like to delete the question
} do

  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, author: user1) }

  describe 'Authenticated user' do
    scenario 'author del question' do
      sign_in(user1)
      visit questions_path
      click_on 'Delete question'

      expect(page).to have_content 'Question was deleted.'
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
    end

    scenario 'not author del question' do
      sign_in(user2)
      visit questions_path

      expect(page).to_not have_link 'Delete question'
    end
  end

  scenario 'Unauthenticated user del question' do
    visit questions_path

    expect(page).to_not have_link 'Delete question'
  end
end
