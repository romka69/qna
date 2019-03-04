require 'rails_helper'

feature 'User can see list of questions' do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question_sequence, 3, author: user) }

  scenario 'view list of questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
