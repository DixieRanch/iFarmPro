require 'rails_helper'

RSpec.describe 'PasswordResets', type: :request do
  context 'when visiting signin page' do
    it 'has password reset link' do
      visit signin_path

      expect(page).to have_link 'password'
    end

    context 'then clicking forgot password link' do
      it 'redirects to password reset page' do
        visit signin_path

        click_link 'password'

        expect(page).to have_title full_title 'Request Password Reset'
      end
    end
  end

  context 'when requesting password reset' do
    it 'redirects to email sent page' do
      visit new_password_reset_path

      fill_in 'Email', with: 'any@email.com'
      click_button 'Request password reset'

      expect(page).to have_title full_title 'Password Reset Email Sent'
      expect(page).to have_selector 'strong', text: 'any@email.com'
    end

    it 'has link to request new password reset on email sent page' do
      visit new_password_reset_path

      fill_in 'Email', with: 'any@email.com'
      click_button 'Request password reset'

      expect(page).to have_link 'HERE!', href: new_password_reset_path
    end

    context 'when user is activated' do
      it 'sends password reset email' do
        visit new_password_reset_path

        fill_in 'Email', with: create(:user, activated: true).email

        expect do
          click_button 'Request password reset'
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
        expect(last_email.subject).to include 'iFarmPro password reset'
      end
    end

    context 'when user is not activated' do
      it 'sends password reset email' do
        visit new_password_reset_path

        fill_in 'Email', with: create(:user, activated: false).email

        expect do
          click_button 'Request password reset'
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
        expect(last_email.subject).to include 'iFarmPro password reset'
      end
    end

    context 'when not a user' do
      it 'does not send password reset email' do
        visit new_password_reset_path

        fill_in 'Email', with: 'not_a_user@example.com'

        expect do
          click_button 'Request password reset'
        end.not_to(change { ActionMailer::Base.deliveries.count })
      end
    end
  end

  context 'when clicking reset link in email' do
    it 'redirects to password reset page' do
      user = create :user
      visit new_password_reset_path
      fill_in 'Email', with: user.email
      click_button 'Request password reset'
      open_email(user.email)

      current_email.click_link 'Reset Password'

      expect(page).to have_title full_title 'Reset Password'
    end

    context 'for unactivated user with correct email and correct reset token' do
      it 'activates user' do
        user = create(:user, activated: false)
        visit new_password_reset_path
        fill_in 'Email', with: user.email
        click_button 'Request password reset'
        open_email(user.email)

        current_email.click_link 'Reset Password'
        user.reload

        expect(user.activated?).to eq(true)
      end
    end

    context 'for unactivated user with correct email but wrong token' do
      it 'does not activate user' do
        user = create(:user, activated: false)
        token = 'wrongtoken'
        visit new_password_reset_path
        fill_in 'Email', with: user.email
        click_button 'Request password reset'

        visit edit_password_reset_path(token, email: user.email)

        user.reload
        expect(user.activated?).to eq(false)
      end
    end
  end

  context 'when reseting password' do
    context 'with expired time stamp' do
      it 'redirects to request page when clicking email link' do
        user = create :user
        user.send_password_reset_email
        user.update(email_digest_created_at: 3.hours.ago)

        open_email(user.email)
        current_email.click_link 'Reset'

        expect(page).to have_title full_title 'Request Password Reset'
        expect(page).to have_css('div.alert.alert-danger', text: 'Expired')
      end

      it 'does not reset the password' do
        user = create :user
        user.send_password_reset_email
        visit edit_password_reset_path(user.email_token,
                                       email: user.email)
        user.update(email_digest_created_at: 3.hours.ago)

        fill_in 'Password',     with: 'new_password'
        fill_in 'Confirmation', with: 'new_password'

        expect do
          click_button 'Reset Your Password'
          user.reload
        end.not_to(change { user.password_digest })
      end
    end

    context 'with non-user email' do
      it 'redirects to email request page with expired flash message' do
        visit edit_password_reset_path('any_token', email: 'Hacker@badguys.net')

        expect(page).to have_title full_title('Request Password Reset')
        expect(page).to have_css('div.alert.alert-danger', text: 'Expired')
      end
    end

    context 'with valid user email, but bad token' do
      it 'redirects to password reset show page' do
        user = create :user
        user.send_password_reset_email
        visit edit_password_reset_path('wrong_token', email: user.email)

        fill_in 'Password',     with: 'new_password'
        fill_in 'Confirmation', with: 'new_password'
        click_button 'Reset Your Password'

        expect(page).to have_title full_title 'Password Reset Email Sent'
      end

      it 'does not reset the password' do
        user = create :user
        user.send_password_reset_email
        visit edit_password_reset_path('wrong_token', email: user.email)

        fill_in 'Password',     with: 'new_password'
        fill_in 'Confirmation', with: 'new_password'

        expect do
          click_button 'Reset Your Password'
          user.reload
        end.not_to(change { user.password_digest })
      end
    end

    context 'with valid user email & token, but invalid password' do
      it 'does not reset the password' do
        user = create :user
        user.send_password_reset_email
        visit edit_password_reset_path(user.email_token,
                                       email: user.email)

        expect do
          click_button 'Reset Your Password'
          user.reload
        end.not_to(change { user.password_digest })
      end

      it 'redirects to password reset form' do
        user = create :user
        user.send_password_reset_email
        visit edit_password_reset_path(user.email_token,
                                       email: user.email)

        click_button 'Reset Your Password'

        expect(page).to have_title full_title 'Reset Password'
      end
    end

    context 'with valid user email & token, and valid password' do
      it 'persists new password' do
        user = create :user
        user.send_password_reset_email
        visit edit_password_reset_path(user.email_token,
                                       email: user.email)

        fill_in 'Password',     with: 'new_password'
        fill_in 'Confirmation', with: 'new_password'

        expect do
          click_button 'Reset Your Password'
          user.reload
        end.to(change { user.password_digest })
      end

      it 'signs in user after reset' do
        user = create :user
        user.send_password_reset_email
        visit edit_password_reset_path(user.email_token,
                                       email: user.email)

        fill_in 'Password',     with: 'new_password'
        fill_in 'Confirmation', with: 'new_password'
        click_button 'Reset Your Password'

        expect(page).to have_link('Sign out')
        expect(page).to have_title full_title 'Add Farm'
      end
    end
  end
end
