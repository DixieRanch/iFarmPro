require 'rails_helper'

describe "Company" do
  let(:user) {create(:user) }
  subject { page }

  describe "signup page" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    it "has correct elements" do
      expect(page).to have_title full_title('Sign up')
      expect(page).to have_selector('h1', text: 'Sign up')
    end


    context "with invalid information" do
      it "should not create a company when user is invalid" do
        fill_in "Company Name", with: "Big Old Farm"
        expect { click_button submit }.not_to change(Company, :count)
      end

      it "should not create a user when company is invalid" do
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "password"
        fill_in "Confirmation", with: "password"
        expect { click_button submit }.not_to change(User, :count)
      end

      it "should show error messages" do
        click_button submit
        expect(page).to have_css('div.alert-danger')
      end
    end

    context "with valid information" do
      before do
        fill_in "Company Name", with: "Big Old Farm"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "password"
        fill_in "Confirmation", with: "password"
      end

      it "should create a company" do
        expect { click_button submit }.to change(Company, :count).by(1)
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      context "after creating company" do
        
        it "sends activation email" do
          expect {
            click_button submit
          }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
        
        it "redirects to Activation Email Sent page" do
          click_button submit
          expect(page).to have_title full_title "Activation Email Sent"
          expect(page).to have_css('div.alert.alert-success', text: 'Welcome')
          expect(page).to have_text 'user@example.com'
        end
        
        context "after activating account" do

          it "displays welcome message on New Farm Page" do
            click_button submit
            open_email('user@example.com')
            current_email.click_link 'Activate'
            expect(page).to have_title full_title 'Add Farm'
            expect(page).to have_css('div.alert.alert-success', 
                                     text: 'Activated!')
          end
        end
      end
    end
  end

  describe "show page" do
    before { sign_in(user) }
    
    it 'has the correct elements' do
      click_link 'Company'
      expect(page).to have_title full_title user.company.name
    end
  end
  
end
