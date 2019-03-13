require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given!(:user) { create :user }
  given!(:question) { create :question, author: user }
  given!(:answer) { create :answer, question: question, author: user }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end

  describe 'Authenticated user as author', js: true do
    background do
      sign_in user
      visit question_path(question)

      click_on 'Edit answer'
    end

    scenario 'edit his answer' do
      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        click_on 'Save answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit his answer with errors' do
      within '.answers' do
        fill_in 'Body', with: ''
        click_on 'Save answer'

        expect(page).to have_content answer.body
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'edit for add attached files' do
      within '.answers' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save answer'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  describe 'Authenticated user as not author', js: true do
    given!(:user2) { create :user }

    scenario "tries to edit other user's answer" do
      sign_in user2
      visit question_path(question)

      expect(page).to_not have_link 'Edit answer'
    end
  end
end
