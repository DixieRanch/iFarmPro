require 'rails_helper'

RSpec.describe 'Shipping', type: :request do
  describe 'new page' do
    it 'displays the title of the shipment' do
      sign_in create(:user)
      shipment = create(:shipment)
      location = create(:freezer_location)
      visit loads_path
      click_link 'Ship Location'
      select(shipment.name, from: 'Shipment')
      click_button 'Select'

      expect(page).to have_selector 'h1', text:
                             'Shipping ' + location.name +
                             ' to ' + shipment.name
    end

    it 'displays lots in the location' do
      sign_in create(:user)
      shipment = create(:shipment)
      location = create(:freezer_location)
      lot = create(:lot, freezer_location: location)
      visit loads_path
      click_link 'Ship Location'
      select(shipment.name, from: 'Shipment')
      click_button 'Select'

      expect(page).to have_selector 'td', text: lot.name
    end
  end
end
