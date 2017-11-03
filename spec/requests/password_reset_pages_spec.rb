require 'rails_helper'

RSpec.describe 'PasswordReset', type: :request do
  let(:user) { create(:user) }

  context 'when visiting signin page' do
    before { visit signin_path }

    it 'has password reset link' do
      expect(page).to have_link 'password'
    end

    context 'and clicking forgot password link' do
      it 'redirects to password reset page' do
        click_link 'password'
        expect(page).to have_title full_title 'Request Password Reset'
      end
    end
  end

  context 'when requesting password reset' do
    context 'when user is activated' do
      before :each do
        visit new_password_reset_path
        fill_in 'Email', with: user.email
      end

      it 'redirects to email sent page' do
        click_button 'Request password reset'
        expect(page).to have_title full_title 'Password Reset Email Sent'
        expect(page).to have_selector 'strong', text: user.email
      end

      it 'has link to request new password reset' do
        click_button 'Request password reset'
        click_link 'HERE!'
        expect(page).to have_title full_title 'Request Password Reset'
      end

      it 'sends password reset email' do
        expect do
          click_button 'Request password reset'
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
        open_email(user.email)
        expect(current_email.to).to include user.email
      end
    end

    context 'when user is not activated' do
      it 'sends reset email' do
        user = create(:user, activated: false)
        visit new_password_reset_path
        fill_in 'Email', with: user.email

        click_button 'Request password reset'

        email = ActionMailer::Base.deliveries.last
        expect(email.to).to eq([user.email])
        expect(email.subject).to eq('iFarmPro password reset')
      end

      context 'with correct email and correct reset token' do
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

      context 'correct email but wrong token' do
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
  end

  context 'when requesting password reset for non-user' do
    before do
      visit new_password_reset_path
      fill_in 'Email', with: 'no_one@example.com'
    end

    it 'does not send email' do
      expect do
        click_button 'Request password reset'
      end.not_to(change { ActionMailer::Base.deliveries.count })
    end

    it 'redirects to email sent page' do
      click_button 'Request password reset'
      expect(page).to have_title full_title 'Password Reset Email Sent'
      expect(page).to have_selector 'strong', text: 'no_one@example.com'
    end
  end

  context 'when clicking reset link in email' do
    it 'redirects to password reset page' do
      visit new_password_reset_path
      fill_in 'Email', with: user.email
      click_button 'Request password reset'
      open_email(user.email)
      current_email.click_link 'Reset Password'
      expect(page).to have_title full_title 'Reset Password'
    end
  end

  context 'when reseting password' do
    let(:fresh_pass) { 'foobarbaz' }

    before do
      visit new_password_reset_path
      fill_in 'Email', with: user.email
      click_button 'Request password reset'
      open_email(user.email)
      current_email.click_link 'Reset Password'
    end

    context 'with expired time stamp' do
      before { user.update_attribute(:password_reset_sent_at, 3.hours.ago) }

      it 'redirects to request page' do
        click_button 'Reset Your Password'
        expect(page).to have_title full_title 'Request Password Reset'
        expect(page).to have_css('div.alert.alert-danger', text: 'Expired')
      end

      it 'does not reset the password' do
        fill_in 'Password',     with: fresh_pass
        fill_in 'Confirmation', with: fresh_pass
        expect do
          click_button 'Reset Your Password'
          user.reload
        end.not_to(change { user.password_digest })
      end
    end

    context 'with correct information and invalid password' do
      it 'does not reset the password' do
        expect do
          click_button 'Reset Your Password'
          user.reload
        end.not_to(change { user.password_digest })
      end

      it 'redirects to password reset form' do
        click_button 'Reset Your Password'
        expect(page).to have_title full_title 'Reset Password'
      end
    end

    context 'with correct information and good password' do
      it 'persists new password' do
        fill_in 'Password',     with: fresh_pass
        fill_in 'Confirmation', with: fresh_pass
        expect do
          click_button 'Reset Your Password'
          user.reload
        end.to(change { user.password_digest })
      end

      it 'signs in user after reset' do
        fill_in 'Password',     with: fresh_pass
        fill_in 'Confirmation', with: fresh_pass
        click_button 'Reset Your Password'
        expect(page).to have_link('Sign out')
        expect(page).to have_title full_title 'Add Farm'
      end
    end
  end

  context 'with good email, but bad token' do
    let(:fresh_pass) { 'foobarbaz' }

    before do
      token = 'wrongtoken'
      email = user.email
      visit new_password_reset_path
      fill_in 'Email', with: user.email
      click_button 'Request password reset'
      visit edit_password_reset_path(token, email: email)
    end

    it 'redirects to password reset show page' do
      user.reload
      fill_in 'Password',     with: fresh_pass
      fill_in 'Confirmation', with: fresh_pass
      click_button 'Reset Your Password'
      expect(page).to have_title full_title 'Password Reset Email Sent'
    end

    it 'does not reset the password' do
      fill_in 'Password',     with: fresh_pass
      fill_in 'Confirmation', with: fresh_pass
      expect do
        click_button 'Reset Your Password'
        user.reload
      end.not_to(change { user.password_digest })
    end
  end

  describe '#edit' do
    context 'with expired timestamp' do
      it 'renders a flash message' do
        user = create(:user)
        visit new_password_reset_path
        fill_in 'Email', with: user.email
        click_button 'Request password reset'
        user.update_attribute(:password_reset_sent_at, 3.hours.ago)
        open_email(user.email)

        current_email.click_link 'Reset Password'

        expect(page).to have_css('div.alert.alert-danger', text: 'Expired')
      end

      it 'redirects to email request page' do
        user = create(:user)
        visit new_password_reset_path
        fill_in 'Email', with: user.email
        click_button 'Request password reset'
        user.update_attribute(:password_reset_sent_at, 3.hours.ago)
        open_email(user.email)

        current_email.click_link 'Reset Password'

        expect(page).to have_title full_title('Request Password Reset')
      end
    end
  end
end
