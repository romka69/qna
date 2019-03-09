require 'rails_helper'

feature 'User can delete file in answer', %q{
  In order to delete file in your answer to a community
  As an author of answer
  I'd like to delete file in the answer
} do

  given!(:user) { create :user }
  given!(:question) { create :question, author: user }
  given!(:answer) { create :answer, author: user, question: question }

  scenario 'Unauthenticated can not del file' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete file'
  end

  describe 'Authenticated user as author', js: true do
    background do
      sign_in user
      visit question_path(question)

      within '.answers' do
        click_on 'Edit answer'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save answer'
      end
    end

    scenario 'add' do
      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'delete' do
      within '.answers' do
        click_on 'Edit answer'

        within ".storage-#{answer.files.first.id}" do
          click_on 'Delete file'
        end

        expect(page).to_not have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      expect(page).to have_content 'File was deleted.'
    end
  end

  describe 'Authenticated user as not author', js: true do
    given!(:user2) { create :user }

    scenario "tries to del file other user's question" do
      sign_in user2
      visit question_path(question)

      expect(page).to_not have_link 'Delete file'
    end
  end
end
