require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask question
  As an unauthenticated user
  I'd like to be able to sign in
} do

  given(:user) { create(:user) }

  background { visit new_user_session_path }

  describe 'Register user' do
    background do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
    end

    scenario 'tries to sign in' do
      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'can logout' do
      click_on 'Log out'

      expect(page).to have_content 'Signed out successfully.'
    end
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'worng@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  scenario 'User can register with email' do
    click_on 'Sign up'
    fill_in 'Email', with: 'acceptance-test@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User can register or login with oAuth' do
    expect(page).to have_content("Sign in with GitHub")
    mock_auth_hash
    click_on 'Sign in with GitHub'

    expect(page).to have_content 'Successfully authenticated from GitHub account.'
  end
end
