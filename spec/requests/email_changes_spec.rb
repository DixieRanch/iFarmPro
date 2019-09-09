require 'rails_helper'

RSpec.describe 'EmailChanges', type: :request do
  context 'account dropdown' do
    context 'change email link' do
      it 'has correct link' do
        user = create(:user)
        sign_in user

        expect(page).to have_link 'Change Email'
      end

      it 'redirects to email change form' do
        user = create(:user)
        sign_in user

        click_link 'Change Email'

        expect(page).to have_title full_title 'Change Email'
      end
    end
  end
end
