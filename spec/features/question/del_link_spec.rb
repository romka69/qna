require 'rails_helper'

feature 'User can delete link in question', %q{
  In order to delete link in your question to a community
  As an author of question
  I'd like to delete link in the question
} do

  given!(:user) { create :user }
  given!(:url) { 'http://ya.ru'}

  describe 'Unauthenticated user' do
    given(:question) { create :question, author: user }
    given(:link) { create :link, linkable: question }

    scenario 'can not del file' do
      visit question_path(question)

      expect(page).to_not have_link 'Delete link'
    end
  end

  describe 'Authenticated user as author', js: true do
    background do
      sign_in user
      visit questions_path

      click_on 'Ask question'

      fill_in 'Title', with: 'Title'
      fill_in 'Body', with: 'Text text text'

      click_on 'Add link'

      fill_in 'Link name', with: 'My href'
      fill_in 'Url', with: url

      click_on 'Ask'
    end

    scenario 'add' do
      expect(page).to have_link 'My href', href: url
    end

    scenario 'delete' do
      click_on 'Delete link'

      expect(page).to_not have_link 'My href', href: url
      expect(page).to have_content 'Link was deleted.'
    end
  end

  describe 'Authenticated user as not author', js: true do
    given(:question) { create :question, author: user }
    given(:link) { create :link, linkable: question }
    given!(:user2) { create :user }

    scenario "tries to del link other user's question" do
      sign_in user2
      visit question_path(question)

      expect(page).to_not have_link 'Delete link'
    end
  end
end
