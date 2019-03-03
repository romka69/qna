require 'rails_helper'

feature 'User can see question with answers for it' do

  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer_sequence, 3, question: question) }

  scenario 'view question with list answers' do
    visit questions_path
    click_on question.title

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
