require 'rails_helper'

feature 'User can vote for resource', %q{
  In order to vote to a community
  As an authenticated user
  I'd like to give my choice
} do
  given(:user) { create :user }
  given(:question) { create :question, author: user }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
    end

    scenario 'Can vote' do
      click_on '^'

      within '.vote-block' do
        expect(page).to have_content '1'
      end
    end
  end
end
