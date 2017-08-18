require 'rails_helper'

describe "AccountActivations" do
  
  let(:user) { create(:user, activated: false) }
  
  before :each do
    user.send_activation_email #Creates activation token and digest
    # user.reload                #Loads new digest from database
  end
  
  context "after clicking link in email" do
    
    it "activates user" do
      open_email(user.email)
      expect { 
        current_email.click_link "Activate"
        user.reload
      }.to change{user.activated}.to(true)
    end
  end
  
  describe ".edit" do
    
    let(:token) { user.activation_token }
    let(:email) { user.email }
    
    context "with correct token and email" do
      
      it "activates user" do
        expect {
          visit edit_account_activation_path(token, email: email)
          user.reload
        }.to change{user.activated}.to(true)
      end
      
      it "signs in user" do
        visit edit_account_activation_path(token, email: email)
        expect(page).to have_link('Sign out')
        expect(page).not_to have_selector('h1', text: 'Sign in')
        expect(page).to have_css('div.alert.alert-success', text:'Activated')
      end
    end
    
    context "with incorrect email" do
      
      let(:email) { 'wrong@example.com' }
      
      it "doesn't activate user" do
        expect {
          visit edit_account_activation_path(token, email: email)
          user.reload
        }.not_to change{user.activated}.from(false)
      end
      
      it "renders account activation request page" do
        visit edit_account_activation_path(token, email: email)
        expect(page).to have_css('div.alert.alert-danger', text:'Invalid')
        expect(page).to have_title full_title 'Request Account Activation'
      end
    end
    
    context "with incorrect token" do
      
      it "doesn't activate user" do
        token = "wrongtoken"
        expect {
          visit edit_account_activation_path(token, email: email)
          user.reload
        }.not_to change{user.activated}.from(false)
      end
    end
  end
  
  context 'when requesting new activation email' do
    
  end
  
  describe '.new' do
    
  end
end