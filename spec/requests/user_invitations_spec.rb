require 'rails_helper'

describe 'UserInvitations' do
  context 'users dropdown' do
    context 'invitation link' do
      it 'does exist' do
        user = create(:user)
        sign_in user

        expect(page).to have_link 'Invite User'
      end

      it 'redirects to invitation form' do
        user = create(:user)
        sign_in user

        click_link 'Invite User'

        expect(page).to have_title full_title 'Invite User'
      end
    end
  end

  describe 'inviting new user' do
    it 'ensures invited email is not already a user' do
      user = create(:user)
      sign_in user
      visit new_user_invitation_path

      fill_in 'Email', with: user.email
      click_button 'Send Invitation'

      expect(page).to have_title full_title 'Invite User'
      expect(page).to have_css('div.alert.alert-danger')
    end

    it 'redirects to root path' do
      user = create(:user)
      sign_in user
      visit new_user_invitation_path

      fill_in 'Email', with: 'newUser@example.com'
      click_button 'Send Invitation'

      expect(page).to have_title full_title 'Schedule'
      expect(page).to have_css('div.alert.alert-success', text: 'sent')
    end

    it 'sends invitation email' do
      user = create(:user)
      sign_in user
      visit new_user_invitation_path

      fill_in 'Email', with: 'newUser@example.com'

      expect do
        click_button 'Send Invitation'
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'creates invitation object' do
      user = create(:user)
      sign_in user
      visit new_user_invitation_path

      fill_in 'Email', with: 'newUser@example.com'

      expect do
        click_button 'Send Invitation'
      end.to change(UserInvitation, :count).by(1)
    end
  end

  context 'when clicking signup link in email' do
    it 'redirects to password setup page' do
      user = create(:user)
      sign_in user
      visit new_user_invitation_path
      fill_in 'Email', with: 'newUser@example.com'
      click_button 'Send Invitation'
      open_email('newUser@example.com')

      current_email.click_link 'Finish Signup'

      expect(page).to have_title full_title 'Finish Signup'
    end
  end
end
