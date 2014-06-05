require 'spec_helper'

describe 'ApplicationPages' do
  let(:user) { FactoryGirl.create(:user) }
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
        Company.current_id = user.company.id
        @farm = FactoryGirl.create(:farm)
        sign_in(user)
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
        should have_selector 'title', text: full_title(user.company.name)
        click_link "Edit User"
        should have_selector 'title', text: full_title('Edit login')
        click_link "Add User"
        should have_selector 'title', text: full_title('Add User')
        click_link "About"
        should have_selector 'title', text: full_title('About')
        click_link "Contact"
        should have_selector 'title', text: full_title('Contact')
        click_link "iFarmPro"
        should have_selector 'title', text: full_title(user.company.name)
        click_link "Sign out"
        should have_selector 'title', text: full_title('')
      end
    end
  end
end