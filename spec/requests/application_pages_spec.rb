require 'spec_helper'

describe 'ApplicationPages' do
  let(:user) { FactoryGirl.create(:user) }
  subject { page }

  before do
    sign_in(user)
    visit root_path
  end

  describe 'sidebar' do
    
    it { should have_css '.sidebar-nav' }

    context 'when not signed in' do
      before do
        click_link 'Sign out'
      end 

      it { should_not have_css '.sidebar-nav' }
    end

    context 'when User has a farm' do
      before do
        click_link 'Sign out'
        Company.current_id = user.company.id
        @farm = FactoryGirl.create(:farm)
        sign_in(user)
      end
      
      it { should have_css('.sidebar-nav', text: @farm.name) }
    end


    it 'should have the correct links' do
      click_link 'Farms'
      expect(page).to have_selector 'title', text: full_title('Farms')
      click_link 'Irrigations'
      expect(page).to have_selector 'title', text: full_title('Irrigations')
      click_link 'Rain'
      expect(page).to have_selector 'title', text: full_title('Rain')
      click_link 'Irrigation'
      expect(page).to have_selector 'title', text: full_title('Next Irrigation')
    end
  end
end