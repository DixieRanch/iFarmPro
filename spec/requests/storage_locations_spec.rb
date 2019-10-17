require 'rails_helper'

RSpec.describe 'StorageLocations', type: :request do
  describe 'Storage Locations link' do
    context 'when clicked' do
      it 'redirects to storage locations form' do
        sign_in(create(:user))
        visit root_path

        click_link 'Storage Locations'

        expect(page).to have_title full_title 'Storage Locations'
      end
    end
  end
  describe 'form' do
    it 'has location_name field' do
      sign_in(create(:user))
      visit root_path
      click_link 'Storage Locations'

      fill_in('Location Name', with: 'newlocation')
    end

    it 'has a submit button' do
      sign_in(create(:user))
      visit root_path
      click_link 'Storage Locations'
      fill_in('Location Name', with: 'location1')

      click_button('Save Location')
    end

    context 'when submitting a blank location name' do
      xit 'renders storage locations index page with correct title' do
        sign_in(create(:user))
        visit root_path
        click_link 'Storage Locations'

        click_button('Save Location')

        expect(page).to have_title full_title 'Storage Locations'
      end

      xit 'shows a danger flash message for Invalid Name' do
        sign_in(create(:user))
        visit root_path
        click_link 'Storage Locations'

        click_button 'Save Location'

        expect(page).to have_css('div.alert.alert-danger',
                                 text: 'Name cannot be blank')
      end
    end

    context 'when submitting a valid location name' do
      it 'adds location to the database' do
        sign_in(user = create(:user))
        visit root_path
        click_link 'Storage Locations'

        fill_in('Location Name', with: 'location1')

        expect do
          click_button('Save Location')
          Company.current_id = user.company_id
        end.to(change { FreezerLocation.count }.by(1))
      end
    end
  end
end
