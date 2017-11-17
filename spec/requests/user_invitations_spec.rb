require 'rails_helper'

describe 'UserInvitations' do
<<<<<<< cfefa529eda5b5f0f7de192cdefd7b86cfdfe062
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
=======
<<<<<<< 4e8e6bbdd5235a0c0194a432d744a0c54af4ed9e
>>>>>>> Add form to submit email for invitations then redirect to schedule
<<<<<<< ff5f42399d58afee8c1a7a40ef6868604f5687b4
<<<<<<< a860b4062addc0fb9c6ea4df7786bf6a22e1fe02
=======
>>>>>>> Add link in header for user invitation
>>>>>>> Add link in header for user invitation
  context 'users dropdown' do
=======
  describe 'users dropdown' do
>>>>>>> Add form to submit email for invitations then redirect to schedule
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
<<<<<<< 6d268003e283b453e98cbad19a49773368bcb9b7
<<<<<<< 07b7e09bea8eb72a4d182a839a3f7a8c1f7bc3f2
>>>>>>> Add link in header for user invitation
=======
=======
<<<<<<< 2b529f10db9209777388b86e990510fe975122d0
>>>>>>> Rubocop cleanup to user_invitations_spec
<<<<<<< ff5f42399d58afee8c1a7a40ef6868604f5687b4
>>>>>>> Add link in header for user invitation
  
=======

<<<<<<< 4e8e6bbdd5235a0c0194a432d744a0c54af4ed9e
>>>>>>> Rubocop cleanup to user_invitations_spec
  describe 'inviting new user' do
=======
  describe 'when inviting new user' do
    it 'redirects to schedule' do
      user = create(:user)
      sign_in user
      click_link 'Invite User'
      fill_in 'Email', with: 'newUser@example.com'

      click_button 'Send Invitation'

      expect(page).to have_title full_title 'Schedule'
    end
<<<<<<< 4178bfb756b00ea44e97a1dcdc655f187c02ea78
    
>>>>>>> Add form to submit email for invitations then redirect to schedule
=======

    it 'displays a message' do
      user = create(:user)
      sign_in user
      click_link 'Invite User'
      fill_in 'Email', with: 'newUser@example.com'

      click_button 'Send Invitation'

      expect(page).to have_css('div.alert.alert-success', text: 'Invitation')
    end

>>>>>>> Add flash message upon successful form submission
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
