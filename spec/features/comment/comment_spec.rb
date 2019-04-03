require 'rails_helper'

feature 'User can comment for resource', %q{
  In order to comment to a community
  As an authenticated user
  I'd like to give my comment
} do
  given(:user) { create :user }
  given!(:question) { create :question, author: user }

  describe 'Not authenticated user' do
    scenario 'Can not comment' do
      visit question_path(question)

      expect(page).to_not have_selector '.new-comment'
    end
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can sent comment' do
      fill_in 'Comment body', with: 'Test comment'
      click_on 'Sent comment'

      expect(page).to have_content 'Test comment'
    end

    scenario 'can not sent comment with errors' do
      click_on 'Sent comment'

      expect(page).to have_content "body can't be blank"
    end
  end

  describe 'multiple sessions', js: true do
    scenario 'comments appears on another users page' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Comment body', with: 'Test comment'
        click_on 'Sent comment'

        expect(page).to have_content 'Test comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test comment'
      end
    end
  end
end
