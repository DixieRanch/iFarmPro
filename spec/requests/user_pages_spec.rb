require 'rails_helper'

describe "UserPages" do
  subject { page }

  describe "authorization" do
    context "for wrong user" do
      let(:user) { create(:user) }
      let(:wrong_user) { create(:user, email: "wrong@example.com") }
      before { sign_in user }

      context "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('Edit login')) }
      end

      context "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end
    
  end

  describe "new" do
    let(:user) { create(:user) }
    let(:attr) { attributes_for(:user) }
    before do
      sign_in user
      visit new_user_path
    end

    context "with invalid information" do
      before do
        fill_in "Email", with: ""
        fill_in "Password", with: ""
        fill_in "Confirmation", with: ""        
      end

      it "should not create a user" do
        expect  do
          click_button "Save"
        end.not_to change(User, :count)
      end

      it "should display error messages" do
        click_button "Save"
        expect(page).to have_css '.alert-danger'
      end
    end

    context "with valid information" do
      before do
        fill_in "Email", with: attr[:email]
        fill_in "Password", with: attr[:password]
        fill_in "Confirmation", with: attr[:password]
      end

      it "should create a new user" do
        expect do
          click_button "Save"
        end.to change(User, :count).by(1)
      end

      it "should create a user for the correct company with success" do
        click_button "Save"
        new_user = User.find_by_email(attr[:email])
        expect(new_user.company_id).to eq user.company_id
        expect(page).to have_css '.alert-success'
      end
    end
  end

  describe "edit" do
    let(:user) { create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end 

    describe "page" do
      it "has correct elements" do
        expect(page).to have_title "Edit login"
        expect(page).to have_selector('h1', text: "Update your login")
      end

      context "with invalid information" do
        before { click_button "Save" }

        it { should have_css('div.alert.alert-danger') }
      end

      context "with valid information" do
        let(:new_email) { "new@example.com" }
        before do
          fill_in "Email",        with: new_email
          fill_in "Password",     with: user.password
          fill_in "Confirmation", with: user.password
          click_button "Save"
        end

        it "displays updated user with success" do
          expect(page).to have_title user.company.name
          expect(page).to have_css('div.alert.alert-success')
          expect(page).to have_link('Sign out', href: signout_path)
          expect(user.reload.email).to eq new_email
        end
      end
    end
  end
end
