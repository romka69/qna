require 'rails_helper'

feature 'User can create answer', %q{
  In order to write answer to a community
  As an authenticated user
  I'd like to give the answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      click_on question.title
    end

    scenario 'write answer', js: true do
      fill_in 'Body', with: 'Text text text'
      click_on 'Sent answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'Text text text'
    end

    scenario 'write answer with errors', js: true do
      click_on 'Sent answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'write answer with attached file', js: true do
      fill_in 'Body', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Sent answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit question_path(question)
    fill_in 'Body', with: 'Text text text'
    click_on 'Sent answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
