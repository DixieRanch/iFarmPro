require 'rails_helper'

describe "Authentication" do
  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it "has the proper elements" do
      expect(page).to have_selector('h1', text: 'Sign in')
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
        before { click_link "iFarmPro" }
        it { should_not have_css('div.alert.alert-danger') }
      end
    end

    context "with valid information" do
      let(:user) { create(:user) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_title full_title 'Add Farm' }

      context "followed by signout" do
        before { click_link "Sign out" }

        it { should have_link('Sign in') }
      end
    end

    context "when account not activated" do
      let(:user) { create(:user, activated: false) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
      end

      it "redirects to Activation Email Sent page" do
        click_button "Sign in"
        expect(page).to have_title full_title 'Activation Email Sent'
        expect(page).to have_link 'Sign in'
      end

      context "when activation email not sent" do
        it "sends email" do
          user.update_attribute(:activation_digest, nil)
          expect {
            click_button "Sign in"
          }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
      end

      context "when activation email previously sent" do
        it "doesn't send email" do
          expect {
            click_button "Sign in"
          }.not_to change { ActionMailer::Base.deliveries.count }
        end
      end
    end
  end

  describe "authorization" do
    let(:user) { create(:user) }

    context "for non-signed-in users" do
      context "when attempting to visit a protected page" do
        before { visit new_farm_path }

        it "redirects to signin" do
          expect(page).to have_title 'Sign in'
          expect(page).to have_css('div.alert.alert-notice')
        end

        it "should render the desired protected page after signing in" do
          sign_in(user)
          expect(page).to have_title full_title 'Add Farm'
        end

        it "should render the Add Farm page when signing in again" do
          sign_in_new(user)
          click_link 'Sign out'
          sign_in_new(user)
          expect(page).to have_title full_title 'Add Farm'
        end
      end

      context "when attempting to access protected action" do
        before { put user_path(user) }

        specify { expect(response).to redirect_to(signin_path) }
      end
    end

    context "for correct company" do
      it "resets Company.current_id after every" do
        sign_in_new(user)
        expect(Company.current_id).not_to be_nil
        visit root_path
        expect(Company.current_id).to be_nil
      end
    end
  end
end
