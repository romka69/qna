require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  describe 'User adds links when asks question' do
    given(:user) { create :user }
    given(:ya_url) { 'https://ya.ru' }
    given(:gist_url) { 'https://gist.github.com/romka69/54370693ce6554b1afceaf0ef0076d36' }
    given(:gist_url2) { 'https://gist.github.com/romka69/00000000000000000000000000000000' }

    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      click_on 'Add link'

      fill_in 'Link name', with: 'My href'
    end

    scenario 'typical url', js: true do
      fill_in 'Url', with: ya_url

      click_on 'Ask'

      expect(page).to have_link 'My href', href: ya_url
    end

    scenario 'gist url', js: true do
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      expect(page).to have_link 'My href', href: gist_url
      expect(page).to have_content 'Simple text'
    end

    scenario 'broken gist url', js: true do
      fill_in 'Url', with: gist_url2

      click_on 'Ask'

      expect(page).to have_link 'My href', href: gist_url2
      expect(page).to have_content 'Not found content in gist'
    end
  end
end
