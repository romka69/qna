require 'rails_helper'

feature 'User can add badge to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add badge
} do

  given(:user) { create :user }

  scenario 'add badge' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Name', with: 'Best badge'
    attach_file 'Img', "#{Rails.root}/spec/rails_helper.rb"

    click_on 'Ask'

    expect(user.questions.last.badge).to be_a(Badge)
  end
end
