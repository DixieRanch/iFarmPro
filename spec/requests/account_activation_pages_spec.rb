require 'rails_helper'

describe "AccountActivations" do
  
  let(:user) { create(:user, activated: false) }
  
  before :each do
    user.send_activation_email # Creates activation token and digest
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
    
    context "when user already has farm setup" do
      
      it "redirects to irrigation schedule" do
        # Company scope must be set to create :field
        Company.current_id = user.company.id
        create(:field)
        # Company scope reset to initial state
        Company.current_id = nil
        visit edit_account_activation_path(token, email: email)
        # puts page.body
        expect(page).to have_title full_title 'Schedule'
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
  
  
  describe '.new' do
    it "renders request account activation page" do
      visit new_account_activation_path
      expect(page).to have_title full_title "Request Account Activation"
      expect(page).to have_selector 'p', text: 'noreply@ifarmpro.com'
      expect(page).to have_selector 'form'
      expect(page).to have_field 'Email'
    end
  end
  
  describe '.create' do
    
    context 'when requesting new activation email' do
      
      before :each do
        visit new_account_activation_path
      end
      
      context "with valid user email" do
        
        before :each do
          fill_in 'Email', with: user.email
        end
        
        it "sends correct email" do
          expect {
            click_button 'Request Email'
          }.to change { ActionMailer::Base.deliveries.count }.by(1)
          open_email(user.email)
          expect(current_email.to).to include user.email
          expect { 
            current_email.click_link "Activate"
            user.reload
          }.to change{user.activated}.to(true)
        end
        
        it "redirects to confirmation email page with flash success message" do
          click_button 'Request Email'
          expect(page).to have_title full_title "Activation Email Sent"
          expect(page).to have_selector 'h1', text: 'confirmation'
          expect(page).to have_selector 'strong', text: user.email
          expect(page).to have_css('div.alert.alert-success', text:'Activation')
        end
      end
      
      context "with invalid user email" do
        
        it "doesn't send email, but looks like it did" do
          fill_in 'Email', with: "not_a_user@hackers.com"
          expect {
            click_button 'Request Email'
          }.not_to change { ActionMailer::Base.deliveries.count }
          expect(page).to have_selector 'h1', text: 'confirmation'
          expect(page).to have_css('div.alert.alert-success', text:'Activation')
        end
      end
    end
  end
end