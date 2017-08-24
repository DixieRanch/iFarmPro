require 'rails_helper'

RSpec.describe "PasswordReset", type: :request do
  
  let(:user) { create(:user) }
  
  context "when visiting signin page" do
    
    before { visit signin_path }
    
    it "has password reset link" do
      expect(page).to have_link 'password'
    end
    
    context "and clicking forgot password link" do
      
      it "redirects to password reset page" do
        click_link 'password'
        expect(page).to have_title full_title 'Request Password Reset'
      end
    end
  end
  
  context "when requesting password reset" do
    
    before :each do
      visit new_password_reset_path
      fill_in 'Email', with: user.email
      click_button "Request password reset"
    end
    
    it "redirects to email sent page" do
      expect(page).to have_title full_title 'Password Reset Email Sent'
      expect(page).to have_selector 'strong', text: user.email
    end
    
    it "has link to request new password reset" do
      click_link 'HERE!'
      expect(page).to have_title full_title 'Request Password Reset'
    end
  end
end