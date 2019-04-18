require 'rails_helper'

feature 'User can subscribe to question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to see notify of new answers in the question
} do
  given(:user) { create :user }
  given(:question) { create :question, author: user }
  given(:user2) { create :user }

  scenario 'authenticated user', js: true do
    sign_in user2
    visit question_path(question)

    click_on 'Subscribe'

    expect(page).to_not have_content 'Subscribe'
    expect(page).to have_content 'Unsubscribe'
  end

  scenario 'Unauthenticated user', js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Subscribe'
  end
end
