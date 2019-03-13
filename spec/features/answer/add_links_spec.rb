require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create :user }
  given(:question) { create :question, author: user }
  given(:gist_url) { 'https://gist.github.com/romka69/54370693ce6554b1afceaf0ef0076d36' }

  scenario 'User adds link when sent answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'text text text'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Sent answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
