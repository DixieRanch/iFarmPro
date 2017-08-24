require 'rails_helper'

RSpec.describe "PasswordReset", type: :request do
  context "when visiting signin page" do
    
    before { visit signin_path }
    
    it "has password reset link" do
      expect(page).to have_link 'password'
    end
    
    context "and clicking forgot password link" do
      
      it "redirects to password reset page" do
        click_link 'password'
        expect(page).to have_title full_title 'Password Reset'
      end
    end
  end
end