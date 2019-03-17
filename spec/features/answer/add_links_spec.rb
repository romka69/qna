require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  describe 'User adds link when sent answer' do
    given(:user) { create :user }
    given(:question) { create :question, author: user }
    given(:ya_url) { 'https://ya.ru' }
    given(:gist_url) { 'https://gist.github.com/romka69/54370693ce6554b1afceaf0ef0076d36' }
    given(:gist_url2) { 'https://gist.github.com/romka69/00000000000000000000000000000000' }

    background do
      sign_in(user)
      visit question_path(question)

      fill_in 'Body', with: 'text text text'

      click_on 'Add link'

      fill_in 'Link name', with: 'My href'
    end

    scenario 'typical url', js: true do
      fill_in 'Url', with: ya_url

      click_on 'Sent answer'

      within '.answers' do
        expect(page).to have_link 'My href', href: ya_url
      end
    end

    scenario 'gist url', js: true do
      fill_in 'Url', with: gist_url

      click_on 'Sent answer'

      within '.answers' do
        expect(page).to have_link 'My href', href: gist_url
        expect(page).to have_content 'Simple text'
      end
    end

    scenario 'broken gist url', js: true do
      fill_in 'Url', with: gist_url2

      click_on 'Sent answer'

      within '.answers' do
        expect(page).to have_link 'My href', href: gist_url2
        expect(page).to have_content 'Not found content in gist'
      end
    end
  end
end
