require 'rails_helper'

RSpec.describe 'ChangeEmail', type: :request do
  context 'when logged in' do
    it 'has change email link' do
      sign_in(create(:user))

      find("a[href='/email_resets/new']")
    end

    context 'when clicking change email link' do
      it 'redirects to change email page' do
        sign_in(create(:user))

        find("a[href='/email_resets/new']").click

        expect(page).to have_title full_title 'Change Email'
      end
    end
  end

  context 'when submiting new email' do
    it 'redirects to email sent page' do
      sign_in(create(:user))
      visit new_email_reset_path

      click_button 'Submit Email'

      expect(page).to have_title full_title 'Change Email, Email Sent'
    end
  end
end
