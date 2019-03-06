require 'rails_helper'

feature 'User can set best answer', %q{
  In order to choosing answer for user
  As an author of question
  I'd like to pick the answer
} do

  given(:user) { create :user }
  given!(:question) { create :question, author: user }
  given!(:answer) { create :answer, question: question, author: user }

  scenario 'Unauthenticated can not pick best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Pick best answer'
  end

  describe 'Authenticated user', js: true do

    given!(:user2) { create :user }
    given!(:answer2) { create :answer, question: question, author: user }

    scenario 'author can pick best answer' do
      sign_in user
      visit question_path(question)

      within ".answer-#{answer.id}" do
        click_on 'Pick best answer'

        expect(page).to have_content 'Best answer'
      end

      expect(page).to have_content 'Answer was picked.'
    end

    scenario 'only one and first best answer' do
      sign_in user
      visit question_path(question)

      within ".answer-#{answer.id}" do
        click_on 'Pick best answer'

        expect(page).to have_content 'Best answer'
      end

      within ".answer-#{answer2.id}" do
        click_on 'Pick best answer'

        expect(page).to have_content 'Best answer'
      end

      within ".answer-#{answer.id}" do
        click_on 'Pick best answer'

        expect(page).to_not have_content 'Best answer'
      end

      within(all('.answers > div').first) do
        expect(page).to have_content 'Best answer'
      end

      within(all('.answers > div').last) do
        expect(page).to_not have_content 'Best answer'
      end
    end

    scenario 'not author can not pick best answer' do
      sign_in user2
      visit question_path(question)

      expect(page).to_not have_link 'Pick best answer'
    end
  end
end