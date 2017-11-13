require 'rails_helper'

describe 'UserInvitations' do
  
  describe 'Email' do
    
    it 'sends invitation' do
      user = create(:user)
      sign_in user
      visit new_user_path
      
      fill_in 'Email', with: 'newUser@example.com'
      
      expect do
        click_button 'Save'
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end