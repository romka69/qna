require 'rails_helper'

feature 'User can see his badges' do
  given(:user) { create :user }
  given!(:question) { create :question, author: user }
  given!(:badge) { create :badge, :with_img, question: question }
  given!(:answer) { create :answer, question: question, author: user }

  it 'visit badge page', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Pick best answer'
    sleep 4
    visit badges_path

    expect(page).to have_content question.title
    expect(page).to have_content badge.name
    expect(page).to have_selector 'img'
  end
end
