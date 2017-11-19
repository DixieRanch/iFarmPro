require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'account_activation' do
    it 'renders the headers' do
      user = create :user

      UserMailer.account_activation(user)

      expect(last_email.subject).to eq('iFarmPro account activation')
      expect(last_email.to).to eq([user.email])
      expect(last_email.from).to eq(['noreply@ifarmpro.com'])
    end

    it 'renders the body' do
      user = create :user

      UserMailer.account_activation(user)

      expect(last_email).to have_selector 'h1', text: 'Welcome to iFarmPro!'
      expect(last_email).to have_link 'Activate',
                                      href: edit_account_activation_url(
                                        user.activation_token,
                                        email: user.email
                                      )
      expect(last_email.body.encoded).to have_selector 'p', text: user.email
    end
  end

  describe 'password_reset' do
    it 'renders the headers' do
      user = create :user

      user.send_password_reset_email

      expect(last_email.subject).to eq('iFarmPro password reset')
      expect(last_email.to).to eq([user.email])
      expect(last_email.from).to eq(['noreply@ifarmpro.com'])
    end

    it 'renders the body' do
      user = create :user

      user.send_password_reset_email

      expect(last_email).to have_selector 'p', text: 'reset your password'
      expect(last_email.body.encoded).to have_selector 'p', text: user.email
      expect(last_email).to have_link 'Reset Password',
                                      href: edit_password_reset_url(
                                        user.password_reset_token,
                                        email: user.email
                                      )
    end
  end
end
