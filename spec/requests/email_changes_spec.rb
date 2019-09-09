require 'rails_helper'

RSpec.describe 'EmailChanges', type: :request do
  describe 'email change link' do
    context 'when user is logged in' do
      it 'account dropdown has change email link' do
        sign_in(create(:user))

        expect(page).to have_link 'Change Email'
      end
    end

    context 'when clicking Change Email link' do
      it 'redirects to change email page' do
        sign_in(create(:user))

        click_link 'Change Email'

        expect(page).to have_title full_title 'Change Email'
      end
    end
  end

  describe 'submit new email form' do
    it 'has a submit button' do
      sign_in(create(:user))

      click_link 'Change Email'

      expect(page).to have_button 'Submit Email'
    end
  end
end
