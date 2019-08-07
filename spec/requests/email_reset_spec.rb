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
        expect(page).to have_css('input[type="text"]')
      end
    end
  end
end
