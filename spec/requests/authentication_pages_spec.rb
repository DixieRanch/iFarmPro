require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it "has the proper elements" do
      expect(page).to have_selector('h1',    text:'Sign in')
      expect(page).to have_title 'Sign in'
      expect(page).to have_link('Sign up now!', href: signup_path)
    end

    context "with invalid information" do
      before { click_button "Sign in" }

      it "redirects to signin" do
        expect(page).to have_title 'Sign in'
        expect(page).to have_css('div.alert.alert-danger', text: 'Invalid')
      end

      context "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_css('div.alert.alert-danger') }
      end
    end

    context "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        Company.current_id = user.company.id
        @farm = FactoryGirl.create(:farm)
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_selector('title', text: user.company.name) }

      context "followed by signout" do
        before { click_link "Sign out" }
        
        it { should have_link('Sign in') }
      end
    end
  end

  describe "authorization" do
    let(:user) { FactoryGirl.create(:user) }

    context "for non-signed-in users" do

      context "when attempting to visit a protected page" do
        before { visit edit_user_path(user) }

        it "redirects to signin" do
          expect(page).to have_title 'Sign in'
          expect(page).to have_css('div.alert.alert-notice')
        end

        it "should render the desired protected page after signing in" do
          sign_in(user)
          expect(page).to have_selector('title', text: 'Edit login')
        end

        it "should render the default(profile) page when signing in again" do
          sign_in(user)
          click_link 'Sign out'
          sign_in(user)
          expect(page).to have_selector('title', text: user.company.name)
        end
      end

      context "when attempting to access protected action" do
        before { put user_path(user) }

        specify { response.should redirect_to(signin_path) }
      end
    end

    context "for correct company" do
      
      it "should return nil for Company.current_id outside of methods" do
        expect(Company.current_id).to be_nil
      end
    end   
  end
end
