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
    end
    
    it "redirects to email sent page" do
      click_button "Request password reset"
      expect(page).to have_title full_title 'Password Reset Email Sent'
      expect(page).to have_selector 'strong', text: user.email
    end
    
    it "has link to request new password reset" do
      click_button "Request password reset"
      click_link 'HERE!'
      expect(page).to have_title full_title 'Request Password Reset'
    end
    
    it "sends password reset email" do
      expect {
      click_button "Request password reset"
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
      open_email(user.email)
      expect(current_email.to).to include user.email
    end
  end
  
  context "when requesting password reset for non-user" do
    
    before do
      visit new_password_reset_path
      fill_in 'Email', with: 'no_one@example.com'
    end
    
    it "does not send email" do
      expect {
      click_button "Request password reset"
      }.not_to change { ActionMailer::Base.deliveries.count }
    end
    
    it "redirects to email sent page" do
      click_button "Request password reset"
      expect(page).to have_title full_title 'Password Reset Email Sent'
      expect(page).to have_selector 'strong', text: 'no_one@example.com'
    end
  end
  
  context "when clicking reset link in email" do
    
    it "redirects to password reset page" do
      visit new_password_reset_path
      fill_in 'Email', with: user.email
      click_button "Request password reset"
      open_email(user.email)
      current_email.click_link 'Reset Password'
      expect(page).to have_title full_title 'Reset Password'
    end
  end
  
  context "when reseting password" do
    
    it "redirects to signin page" do
      visit new_password_reset_path
      fill_in 'Email', with: user.email
      click_button "Request password reset"
      open_email(user.email)
      current_email.click_link 'Reset Password'
      click_button "Reset Your Password"
      expect(page).to have_title full_title 'Sign in' # Placeholder landing page
    end
  end
end