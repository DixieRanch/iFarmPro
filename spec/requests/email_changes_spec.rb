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

  describe 'new email form' do
    context 'when submiting new email' do
      it 'updates new_email attribute' do
        user = create(:user)
        sign_in(user)

        click_link 'Change Email'
        fill_in('New Email', with: 'new@email.com')
        click_button('Submit Email')

        user.reload

        expect(user.new_email).to eq 'new@email.com'
      end
    end
    
    context 'when submitting non email' do
      it 'does not update new_email attribute' do
        user = create(:user)
        sign_in(user)

        click_link 'Change Email'
        fill_in('New Email', with: 'notanemail.com')
        click_button('Submit Email')
        user.reload
        
        expect(user.new_email).to be_nil
        
      end
    end
  end
end
