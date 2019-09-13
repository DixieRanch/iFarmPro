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

        expect(page).to have_title full_title 'Request Email Change'
      end
    end
  end

  describe 'new email form' do
    context 'when submiting new email' do
      it 'redirects to email sent show page' do
        user = create(:user)
        sign_in(user)

        click_link 'Change Email'
        fill_in('New Email', with: 'new@email.com')
        click_button('Submit Email')

        expect(page). to have_title full_title 'Change Email, Email Sent'
      end
    end

    context 'when submitting an invalid email' do
      it 'Renders new email form page with danger flash' do
        user = create(:user)
        sign_in(user)

        click_link 'Change Email'
        fill_in('New Email', with: 'notanemail.com')
        click_button('Submit Email')

        expect(page).to have_title full_title 'Request Email Change'
        expect(page).to have_css('div.alert.alert-danger',
                                 text: 'Invalid Email Address')
      end
    end
  end
end
