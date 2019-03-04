require 'rails_helper'

feature 'User can see question with answers for it' do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answers) { create_list(:answer_sequence, 3, question: question, author: user) }

  scenario 'view question with list answers' do
    visit questions_path
    click_on question.title

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
