require 'rails_helper'

RSpec.describe 'FreezerLocations', type: :request do
  describe 'Storage Locations link' do
    context 'when clicked' do
      it 'redirects to storage locations page' do
        sign_in(create(:user))

        click_link 'Storage Locations'

        expect(page).to have_title full_title 'Storage Locations'
      end
    end
  end
  describe 'form' do
    it 'has location_name field' do
      sign_in(create(:user))
      visit freezer_locations_path

      fill_in('Location Name', with: 'newlocation')
    end

    it 'has a submit button' do
      sign_in(create(:user))
      visit freezer_locations_path

      click_button('Save Location')
    end

    context 'when submitting a blank location name' do
      it 'renders storage locations index page with correct title' do
        sign_in(create(:user))
        visit freezer_locations_path

        click_button('Save Location')

        expect(page).to have_title full_title 'Storage Locations'
      end

      it 'indicates field with error' do
        sign_in(create(:user))
        visit freezer_locations_path

        click_button 'Save Location'

        expect(page).to have_css('div.has-error')
      end
    end

    context 'when submitting a valid location name' do
      it 'adds location to the database' do
        sign_in(user = create(:user))
        visit freezer_locations_path

        fill_in('Location Name', with: 'location1')

        expect do
          click_button('Save Location')
          Company.current_id = user.company_id
        end.to(change { FreezerLocation.count }.by(1))
      end

      it 'flashes success message' do
        sign_in(create(:user))
        visit freezer_locations_path
        fill_in('Location Name', with: 'location1')

        click_button 'Save Location'

        expect(page).to have_css '.alert-success'
      end
    end
  end

  describe 'locations list' do
    it 'has list title' do
      sign_in(create(:user))
      visit freezer_locations_path

      expect(page).to have_selector 'h1', text: 'Locations'
    end

    it 'has created locations' do
      sign_in(user = create(:user))
      farm = user.company.farms.first
      create(:freezer_location, name: 'location1', farm: farm)
      create(:freezer_location, name: 'location2', farm: farm)
      visit freezer_locations_path

      expect(page).to have_selector 'td', text: 'location1'
      expect(page).to have_selector 'td', text: 'location2'
    end

    it 'has edit links' do
      sign_in(user = create(:user))
      farm = user.company.farms.first
      location1 = create(:freezer_location, name: 'location1', farm: farm)
      visit freezer_locations_path

      expect(page).to have_link 'edit',
                                href: edit_freezer_location_path(location1)
    end

    context 'with 31 locations' do
      it 'has pagination links' do
        sign_in(user = create(:user))
        farm = user.company.farms.first

        31.times do |l|
          create(:freezer_location, name: 'location' + l.to_s, farm: farm)
        end
        visit freezer_locations_path

        expect(page).to have_css "//*[@class='pagination']//a[text()='2']"
      end
    end
  end

  describe 'edit link' do
    context 'when clicked' do
      it 'renders the storage locations page' do
        sign_in(user = create(:user))
        farm = user.company.farms.first
        create(:freezer_location, name: 'location1', farm: farm)
        visit freezer_locations_path

        click_link 'edit'

        expect(page).to have_title full_title 'Storage Locations'
      end
    end
  end

  describe 'edit form' do
    context 'with valid input' do
      it 'updates location data' do
        sign_in(user = create(:user))
        farm = user.company.farms.first
        create(:freezer_location, name: 'location1', farm: farm)
        visit freezer_locations_path
        click_link 'edit'

        fill_in('Location Name', with: 'location2')
        click_button 'Save Location'

        expect(page).to have_selector 'td', text: 'location2'
        expect(page).to_not have_selector 'td', text: 'location1'
      end

      it 'flashes success message' do
        sign_in(user = create(:user))
        farm = user.company.farms.first
        create(:freezer_location, name: 'location1', farm: farm)
        visit freezer_locations_path
        click_link 'edit'

        fill_in('Location Name', with: 'location2')
        click_button 'Save Location'

        expect(page).to have_css '.alert-success'
      end
    end

    context 'with invalid input' do
      it 'indicates field with error' do
        sign_in(user = create(:user))
        farm = user.company.farms.first
        create(:freezer_location, name: 'location1', farm: farm)
        visit freezer_locations_path
        click_link 'edit'

        fill_in('Location Name', with: '')
        click_button 'Save Location'

        expect(page).to have_css('div.has-error')
      end
    end
  end
end
