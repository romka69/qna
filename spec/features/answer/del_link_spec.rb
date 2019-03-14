require 'rails_helper'

feature 'User can delete link in answer', %q{
  In order to delete link in your answer to a community
  As an author of answer
  I'd like to delete link in the answer
} do

  given!(:user) { create :user }
  given!(:question) { create :question, author: user }
  given!(:url) { 'http://ya.ru'}

  scenario 'Unauthenticated can not del file' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete link'
  end

  describe 'Authenticated user as author', js: true do
    background do
      sign_in user
      visit question_path(question)

      fill_in 'Body', with: 'Text text text'

      click_on 'Add link'

      fill_in 'Link name', with: 'My href'
      fill_in 'Url', with: url

      click_on 'Sent answer'
    end

    scenario 'add' do
      within '.answers' do
        expect(page).to have_link 'My href', href: url
      end
    end

    scenario 'delete' do
      within '.answers' do
        click_on 'Delete link'

        expect(page).to_not have_link 'My href', href: url
      end

      expect(page).to have_content 'Link was deleted.'
    end
  end

  describe 'Authenticated user as not author', js: true do
    given(:link) { create :link, linkable: question }
    given!(:user2) { create :user }

    scenario "tries to del link other user's question" do
      sign_in user2
      visit question_path(question)

      expect(page).to_not have_link 'Delete link'
    end
  end
end
