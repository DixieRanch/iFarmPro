require 'rails_helper'

describe 'UserInvitations' do
<<<<<<< 84a0048ff6f4b662458f387269bf6cf48390ad1d
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
<<<<<<< 33f952a4b10ddc48a7f817b0eeda9c6df41c87a5
<<<<<<< c883329a46ccbd2e7c6b5e17b55cb39b418ba96c
=======
>>>>>>> Add integration test for when an invited email is already a user.
    it 'ensures invited email is not already a user' do
      user = create(:user)
      sign_in user
      visit new_user_invitation_path

      fill_in 'Email', with: user.email
      click_button 'Send Invitation'

      expect(page).to have_title full_title 'Invite User'
      expect(page).to have_css('div.alert.alert-danger')
    end

<<<<<<< 33f952a4b10ddc48a7f817b0eeda9c6df41c87a5
=======
>>>>>>> Add tests to untested controller actions (flash message & redirect).
=======
>>>>>>> Add integration test for when an invited email is already a user.
    it 'redirects to root path' do
      user = create(:user)
      sign_in user
      visit new_user_invitation_path

      fill_in 'Email', with: 'newUser@example.com'
      click_button 'Send Invitation'

      expect(page).to have_title full_title 'Schedule'
      expect(page).to have_css('div.alert.alert-success', text: 'sent')
    end

<<<<<<< 278158dee96358fd10462c603a27b11a65eba5d7
<<<<<<< c883329a46ccbd2e7c6b5e17b55cb39b418ba96c
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
<<<<<<< bc513cb5c10ce9ccd710becb245b5c576f264b3a
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
<<<<<<< 1a8b355eff77c2d9be30f852d11abbb654669aa9
<<<<<<< 6e6a2735e781d96d3fd4e8e6bd1631672ad42367
=======
>>>>>>> Add expired invitation handling to user_invitations.

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

    context 'with uninvited email' do
      it 'redirects to home page' do
        invitation_token = UserInvitation.new_token
        visit edit_user_invitation_path(invitation_token,
                                        email: 'wrong@email.com',
                                        company_id: 1)

        expect(current_path).to eq '/'
      end
    end

    context 'with valid email, token, and password' do
      it 'redirects to schedule' do
        user = create(:user)
        sign_in user
        visit new_user_invitation_path
        fill_in 'Email', with: 'newUser@example.com'
        click_button 'Send Invitation'
        open_email('newUser@example.com')
        current_email.click_link 'Finish Signup'

        fill_in 'Password',     with: 'password'
        fill_in 'Confirmation', with: 'password'
        click_button 'Finish Signup'

        expect(page).to have_title full_title 'Schedule'
      end

      it 'creates a new user' do
        user = create(:user)
        sign_in user
        visit new_user_invitation_path
        fill_in 'Email', with: 'newUser@example.com'
        click_button 'Send Invitation'
        open_email('newUser@example.com')
        current_email.click_link 'Finish Signup'

        fill_in 'Password',     with: 'password'
        fill_in 'Confirmation', with: 'password'

        expect do
          click_button 'Finish Signup'
        end.to change(User, :count).by(1)
      end

      it 'activates the new user' do
        user = create(:user)
        sign_in user
        visit new_user_invitation_path
        fill_in 'Email', with: 'newUser@example.com'
        click_button 'Send Invitation'
        open_email('newUser@example.com')
        current_email.click_link 'Finish Signup'

        fill_in 'Password',     with: 'password'
        fill_in 'Confirmation', with: 'password'
        click_button 'Finish Signup'

        expect(User.last.activated?).to be true
      end

      it 'has welcome flash message' do
        user = create(:user)
        sign_in user
        visit new_user_invitation_path
        fill_in 'Email', with: 'newUser@example.com'
        click_button 'Send Invitation'
        open_email('newUser@example.com')
        current_email.click_link 'Finish Signup'

        fill_in 'Password',     with: 'password'
        fill_in 'Confirmation', with: 'password'
        click_button 'Finish Signup'

        expect(page).to have_css('div.alert.alert-success', text: 'Welcome')
      end
    end
  end
<<<<<<< 1a8b355eff77c2d9be30f852d11abbb654669aa9
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
=======
>>>>>>> resolve merge issues within user_invitations_spec
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
<<<<<<< 84a0048ff6f4b662458f387269bf6cf48390ad1d
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
=======
>>>>>>> resolve merge issues within user_invitations_spec

  describe 'inviting new user' do
=======
>>>>>>> Add tests to untested controller actions (flash message & redirect).
    xit 'sends invitation email' do
=======
    it 'sends invitation email' do
>>>>>>> Add email sending functionality to user invitations
      user = create(:user)
      sign_in user
      visit new_user_invitation_path

      fill_in 'Email', with: 'newUser@example.com'

      expect do
        click_button 'Send Invitation'
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    xit 'creates invitation object' do
=======
>>>>>>> Add test that new UserInvitation object is created after filling out the invitation form.
      user = create(:user)
      sign_in user
      visit new_user_invitation_path

      fill_in 'Email', with: 'newUser@example.com'

      expect do
        click_button 'Send Invitation'
      end.to change(UserInvitation, :count).by(1)
    end
<<<<<<< 84a0048ff6f4b662458f387269bf6cf48390ad1d
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
=======
  end
=======
>>>>>>> Add email link to form for completing invitation signup
=======
>>>>>>> Add expired invitation handling to user_invitations.
end
>>>>>>> resolve merge issues within user_invitations_spec
