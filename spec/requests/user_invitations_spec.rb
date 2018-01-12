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

      it 'has expired flash message after clicking email link' do
        user = create(:user)
        sign_in user
        visit new_user_invitation_path
        fill_in 'Email', with: 'newUser@example.com'
        click_button 'Send Invitation'
        open_email('newUser@example.com')
        invitation = UserInvitation.with_email('newUser@example.com')
        invitation.update_attributes(invitation_sent_at: 8.days.ago)

        current_email.click_link 'Finish Signup'

        expect(page).to have_css('div.alert.alert-danger', text: 'expired')
      end

      it 'has expired flash message after directly accessing link' do
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

        click_button 'Finish Signup'

        expect(page).to have_css('div.alert.alert-danger', text: 'expired')
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

      it 'has expired flash message' do
        invitation_token = UserInvitation.new_token
        visit edit_user_invitation_path(invitation_token,
                                        email: 'wrong@email.com')

        expect(page).to have_css('div.alert.alert-danger', text: 'expired')
      end
    end

    context 'with valid email, and bad token', :focus do
      it 'redirects to home page' do
        invitation = UserInvitation.new(email: 'newUser@example.com')
        invitation.send_invitation_email
        visit edit_user_invitation_path('bad token', email: invitation.email)

        click_button 'Finish Signup'

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
end
