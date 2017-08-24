require 'rails_helper'

RSpec.describe "PasswordReset", type: :request do
  context "when visiting signin page" do
    
    it "has password reset link" do
      visit signin_path
      expect(page).to have_link 'password'
    end
  end
end
