require 'rails_helper'

describe 'Users' do
  describe 'new user form' do
    context 'with invalid information' do
      it 'does not create a user' do
        sign_in create(:user)
        visit new_user_path

        expect do
          click_button 'Save'
        end.not_to change(User, :count)
      end

      it 'displays error messages' do
        sign_in create(:user)
        visit new_user_path

        click_button 'Save'

        expect(page).to have_css '.alert-danger'
      end
    end

    context 'with valid information' do
      it 'should create a new user' do
        sign_in create(:user)
        visit new_user_path

        fill_in 'Email',        with: 'Valid@email.com'
        fill_in 'Password',     with: 'valid_password'
        fill_in 'Confirmation', with: 'valid_password'

        expect do
          click_button 'Save'
        end.to change(User, :count).by(1)
      end

      it 'should create a user for the correct company with success' do
        sign_in user = create(:user)
        visit new_user_path

        fill_in 'Email',        with: 'Valid@email.com'
        fill_in 'Password',     with: 'valid_password'
        fill_in 'Confirmation', with: 'valid_password'
        click_button 'Save'

        new_user = User.find_by(email: 'Valid@email.com')
        expect(new_user.company_id).to eq user.company_id
        expect(page).to have_css '.alert-success'
      end
    end
  end

  describe 'change password link' do
    it 'renders password reset email sent page' do
      sign_in create(:user)

      click_link 'Change Password'

      expect(page).to have_title full_title 'Password Reset Email Sent'
    end

    it 'sends password reset email to current user' do
      sign_in user = create(:user)

      click_link 'Change Password'

      expect(last_email.to).to eq [user.email]
      expect(last_email.subject).to include 'password reset'
    end
  end
end
