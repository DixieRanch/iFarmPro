require 'rails_helper'

describe 'UserInvitations' do
<<<<<<< ff5f42399d58afee8c1a7a40ef6868604f5687b4
<<<<<<< a860b4062addc0fb9c6ea4df7786bf6a22e1fe02
=======
>>>>>>> Add link in header for user invitation
  context 'users dropdown' do
    it 'has invitation link' do
      user = create(:user)
      sign_in user

      expect(page).to have_link 'Invite User'
    end
  end
<<<<<<< 2b529f10db9209777388b86e990510fe975122d0
<<<<<<< ff5f42399d58afee8c1a7a40ef6868604f5687b4
  
=======

>>>>>>> Rubocop cleanup to user_invitations_spec
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
=======
  end
end
>>>>>>> Add failing test for user invitation email
=======
  end
end
>>>>>>> Add link in header for user invitation
