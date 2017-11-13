require 'rails_helper'

describe 'UserInvitations' do
<<<<<<< a860b4062addc0fb9c6ea4df7786bf6a22e1fe02
  context 'users dropdown' do
    it 'has invitation link' do
      user = create(:user)
      sign_in user
      
      expect(page).to have_link "Invite User"
    end
  end
  
  describe 'inviting new user' do
    xit 'sends invitation email' do
      user = create(:user)
      sign_in user
      visit new_user_path

      fill_in 'Email', with: 'newUser@example.com'

=======
  
  describe 'Email' do
    
    it 'sends invitation' do
      user = create(:user)
      sign_in user
      visit new_user_path
      
      fill_in 'Email', with: 'newUser@example.com'
      
>>>>>>> Add failing test for user invitation email
      expect do
        click_button 'Save'
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
<<<<<<< a860b4062addc0fb9c6ea4df7786bf6a22e1fe02

    xit 'creates invitation object' do
      user = create(:user)
      sign_in user
      visit new_user_path

      fill_in 'Email', with: 'newUser@example.com'

      expect do
        click_button 'Save'
      end.to change(UserInvitation, :count).by(1)
    end
  end
end
=======
  end
end
>>>>>>> Add failing test for user invitation email
