require 'spec_helper'

describe 'ApplicationPages' do
  let(:user) { create(:user) }
  subject { page }

  before do
    visit root_path
  end

  describe 'sidebar' do
    
    context 'when not signed in' do

      it { should_not have_css '.sidebar-nav' }
    end

    context 'when signed in' do
      before do
        sign_in(user)
        @farm = Farm.first
      end

      it 'should have the correct sidebar elements and links' do
        expect(page).to have_css('#sidebar', text: @farm.name)
        click_link 'Farms'
        expect(page).to have_selector 'title', text: full_title('Farms')
        click_link 'Irrigations'
        expect(page).to have_selector 'title', text: full_title('Irrigations')
        click_link 'Rain'
        expect(page).to have_selector 'title', text: full_title('Rain')
        click_link 'Soil Products'
        expect(page).to have_title full_title('Soil Products')
        click_link 'Soil Applications'
        expect(page).to have_title full_title 'Soil Applications'
        click_link 'Irrigation'
        expect(page).to have_selector 'title', text: full_title('Next Irrigation')
      end
    end
  end

  describe "layout links" do
    
    context "when signed out" do

      it "should have the correct links" do
        visit root_path
        click_link "Help"
        should have_selector 'title', text: full_title('Help')
        click_link "Sign in"
        should have_selector 'title', text: full_title('Sign in')
        click_link "About"
        should have_selector 'title', text: full_title('About')
        click_link "Contact"
        should have_selector 'title', text: full_title('Contact')
        click_link "iFarmPro"
        should have_selector 'title', text: full_title('')
        click_link "Sign up now!"
        should have_selector 'title', text: full_title('Sign up')
      end
    end

    context "when signed in" do

      it "should have the correct links" do
        sign_in(user)
        click_link "Help"
        should have_selector 'title', text: full_title('Help')
        click_link "Company"
        should have_title full_title(user.company.name)
        click_link "Edit User"
        should have_selector 'title', text: full_title('Edit login')
        click_link "Add User"
        should have_selector 'title', text: full_title('Add User')
        click_link "About"
        should have_selector 'title', text: full_title('About')
        click_link "Contact"
        should have_selector 'title', text: full_title('Contact')
        click_link "iFarmPro"
        should have_title full_title 'Next Irrigations'
        click_link "Sign out"
        should have_selector 'title', text: full_title('')
      end
    end
  end

  describe 'New User signup' do

    before do
      click_link 'Sign up now!'
      fill_in 'Company Name', with: 'New Company'
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password'
      fill_in 'Confirmation', with: 'password'
      click_button 'Create my account'
    end
    
    it "goes from initial setup to irrigation schedule", {js:true} do

      # Initial sign up

      expect(page).to have_title 'Add Farm'
      click_link 'iFarmPro'
      expect(page).to have_title full_title 'Add Farm'

      # Sign in before creating First Farm

      click_link 'Account'
      click_link 'Sign out'
      click_link 'Sign in'
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Sign in'
      expect(page).to have_title full_title 'Add Farm'
      fill_in 'Farm Name', with: 'First Farm'
      click_button 'Save'
      click_link 'iFarmPro'
      expect(page).to have_title full_title 'Edit First Farm'

      # Sign in before creating First Field

      click_link 'Account'
      click_link 'Sign out'
      click_link 'Sign in'
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Sign in'
      expect(page).to have_title full_title 'Edit First Farm'      
      click_link 'Add Block'
      click_link 'Add Field'
      fill_in 'Block', with: 1
      fill_in 'Field', with: 1
      click_button 'Save'
      expect(page).to have_title full_title 'First Farm'
      click_link 'iFarmPro'
      expect(page).to have_title full_title 'Next Irrigations'

      # Sign in after completing setup

      click_link 'Account'
      click_link 'Sign out'
      click_link 'Sign in'
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Sign in'
      expect(page).to have_title full_title 'Next Irrigations'      
    end

    it "redirects to farm setup until complete" do
      click_link 'Irrigations'
      expect(page).to have_title full_title 'Add Farm'
      expect(page).to have_css '.alert-info'
      fill_in 'Farm Name', with: 'First Farm'
      click_button 'Save'
      expect(page).to have_title full_title 'Edit First Farm'
      click_link 'Irrigations'
      expect(page).to have_title full_title 'Edit First Farm'
    end
  end
end