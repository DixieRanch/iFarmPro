require 'rails_helper'

describe 'UserInvitations' do
<<<<<<< 4e8e6bbdd5235a0c0194a432d744a0c54af4ed9e
<<<<<<< ff5f42399d58afee8c1a7a40ef6868604f5687b4
<<<<<<< a860b4062addc0fb9c6ea4df7786bf6a22e1fe02
=======
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
<<<<<<< 2b529f10db9209777388b86e990510fe975122d0
<<<<<<< ff5f42399d58afee8c1a7a40ef6868604f5687b4
  
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
    
>>>>>>> Add form to submit email for invitations then redirect to schedule
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
=======
  end
end
>>>>>>> Add failing test for user invitation email
=======
  end
end
>>>>>>> Add link in header for user invitation
