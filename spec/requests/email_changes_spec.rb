require 'rails_helper'

RSpec.describe 'EmailChanges', type: :request do
  describe 'link' do
    context 'with logged in user' do
      it 'is present' do
        sign_in(create(:user))

        expect(page).to have_link 'Change Email'
      end
    end

    context 'when clicked' do
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

      it 'persists new_email to user' do
        user = create(:user)
        sign_in(user)

        click_link 'Change Email'
        fill_in('New Email', with: 'new@email.com')
        click_button('Submit Email')

        user.reload

        expect(user.new_email).to eq 'new@email.com'
      end
    end

    context 'when submitting an invalid email' do
      it 'renders new email form page' do
        user = create(:user)
        sign_in(user)

        click_link 'Change Email'
        fill_in('New Email', with: 'notanemail.com')
        click_button('Submit Email')

        expect(page).to have_title full_title 'Request Email Change'
      end

      it 'flashes danger message' do
        user = create(:user)
        sign_in(user)

        click_link 'Change Email'
        fill_in('New Email', with: 'notanemail.com')
        click_button('Submit Email')

        expect(page).to have_css('div.alert.alert-danger',
                                 text: 'Invalid Email Address')
      end

      it 'does not persist new_email to user' do
        user = create(:user)
        sign_in(user)

        click_link 'Change Email'
        fill_in('New Email', with: 'notanemail.com')
        click_button('Submit Email')

        user.reload

        expect(user.new_email).to be_nil
      end
    end

    context 'with logged out user' do
      it 'is not present' do
        expect(page).not_to have_link 'Change Email'
      end
    end
  end
end
