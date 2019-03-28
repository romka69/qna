require 'rails_helper'

feature 'User can vote for resource', %q{
  In order to vote to a community
  As an authenticated user
  I'd like to give my choice
} do
  given(:user) { create :user }
  given(:user2) { create :user }
  given!(:question) { create :question, author: user }

  describe 'Not authenticated user' do
    scenario 'Can not vote' do
      visit questions_path

      expect(page).to_not have_selector '.vote-block'
    end
  end

  describe 'Authenticated user as author' do
    scenario 'Can not vote' do
      sign_in(user)
      visit questions_path

      expect(page).to_not have_selector '.vote'
    end
  end

  describe 'Authenticated user not author', js: true do
    background do
      sign_in(user2)
      visit question_path(question)
    end

    scenario 'can vote up' do
      click_on '^'

      within '.vote-block' do
        expect(page).to have_content '1'
      end
    end

    scenario 'can vote down' do
      click_on 'v'

      within '.vote-block' do
        expect(page).to have_content '-1'
      end
    end

    scenario 'can not vote up 2 times' do
      click_on '^'
      sleep 1
      click_on '^'

      within '.vote-block' do
        expect(page).to have_content '1'
      end
    end

    scenario 'can not vote down 2 times' do
      click_on 'v'
      sleep 1
      click_on 'v'

      within '.vote-block' do
        expect(page).to have_content '-1'
      end
    end

    scenario 'can re-voted' do
      click_on '^'

      within '.vote-block' do
        expect(page).to have_content '1'
      end

      click_on 'v'

      within '.vote-block' do
        expect(page).to have_content '0'
      end

      click_on 'v'

      within '.vote-block' do
        expect(page).to have_content '-1'
      end
    end
  end
end
