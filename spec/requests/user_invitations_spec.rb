require 'rails_helper'

describe 'UserInvitations' do
<<<<<<< 07b7e09bea8eb72a4d182a839a3f7a8c1f7bc3f2
<<<<<<< 1a769090a3bf0830502328c33ef42eeb83d8f2c0
<<<<<<< 4758e59549eaaeba3177098b8ebac53797e7e52d
<<<<<<< 492c9c9b8312d6276992559b1ec68fb78b5b6677
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

  context 'when setting password' do
    context 'with expired time stamp' do
      it 'redirects to home page after clicking email link' do
        user = create(:user)
        sign_in user
        visit new_user_invitation_path
        fill_in 'Email', with: 'newUser@example.com'
        click_button 'Send Invitation'
        open_email('newUser@example.com')
        invitation = UserInvitation.with_email('newUser@example.com')
        invitation.update_attributes(invitation_sent_at: 8.days.ago)

        current_email.click_link 'Finish Signup'

        expect(current_path).to eq '/'
      end

      it 'does not set the password' do
        user = create(:user)
        sign_in user
        visit new_user_invitation_path
        fill_in 'Email', with: 'newUser@example.com'
        click_button 'Send Invitation'
        invitation = UserInvitation.with_email('newUser@example.com')
        invitation_token = UserInvitation.new_token
        invitation.invitation_digest = UserInvitation.digest(invitation_token)
        visit edit_user_invitation_path(invitation_token,
                                        email: invitation.email)
        invitation.update_attributes(invitation_sent_at: 8.days.ago)

        fill_in 'Password',     with: 'password'
        fill_in 'Confirmation', with: 'password'

        expect do
          click_button 'Finish Signup'
        end.not_to change(User, :count)
      end
    end
  end
end
=======
=======
=======
<<<<<<< a860b4062addc0fb9c6ea4df7786bf6a22e1fe02
>>>>>>> Add failing test for user invitation email
=======
<<<<<<< ff5f42399d58afee8c1a7a40ef6868604f5687b4
<<<<<<< a860b4062addc0fb9c6ea4df7786bf6a22e1fe02
=======
>>>>>>> Add link in header for user invitation
>>>>>>> Add link in header for user invitation
  context 'users dropdown' do
    it 'has invitation link' do
      user = create(:user)
      sign_in user
      
      expect(page).to have_link "Invite User"
    end
  end
<<<<<<< 07b7e09bea8eb72a4d182a839a3f7a8c1f7bc3f2
>>>>>>> Add link in header for user invitation
=======
<<<<<<< ff5f42399d58afee8c1a7a40ef6868604f5687b4
>>>>>>> Add link in header for user invitation
  
  describe 'inviting new user' do
    xit 'sends invitation email' do
      user = create(:user)
      sign_in user
      visit new_user_path

      fill_in 'Email', with: 'newUser@example.com'

=======
=======
>>>>>>> Add link in header for user invitation
  
  describe 'inviting new user' do
    xit 'sends invitation email' do
      user = create(:user)
      sign_in user
      visit new_user_path

      fill_in 'Email', with: 'newUser@example.com'
<<<<<<< ff5f42399d58afee8c1a7a40ef6868604f5687b4
      
>>>>>>> Add failing test for user invitation email
=======

>>>>>>> Add link in header for user invitation
      expect do
        click_button 'Save'
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
<<<<<<< ff5f42399d58afee8c1a7a40ef6868604f5687b4
<<<<<<< a860b4062addc0fb9c6ea4df7786bf6a22e1fe02
=======
>>>>>>> Add link in header for user invitation

    xit 'creates invitation object' do
      user = create(:user)
      sign_in user
      visit new_user_path

      fill_in 'Email', with: 'newUser@example.com'

      expect do
        click_button 'Save'
      end.to change(UserInvitation, :count).by(1)
    end
<<<<<<< ff5f42399d58afee8c1a7a40ef6868604f5687b4
  end
end
<<<<<<< 1a769090a3bf0830502328c33ef42eeb83d8f2c0
<<<<<<< 4758e59549eaaeba3177098b8ebac53797e7e52d
>>>>>>> Add failing test for user invitation email
=======
>>>>>>> Add link in header for user invitation
=======
=======
  end
end
>>>>>>> Add failing test for user invitation email
<<<<<<< 07b7e09bea8eb72a4d182a839a3f7a8c1f7bc3f2
>>>>>>> Add failing test for user invitation email
=======
=======
  end
end
>>>>>>> Add link in header for user invitation
>>>>>>> Add link in header for user invitation
