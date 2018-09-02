require 'rails_helper'

describe 'Users' do
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
