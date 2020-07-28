require 'rails_helper'

RSpec.describe 'ShipmentSelections', type: :request do
  describe 'new page' do
    it 'has correct title' do
      sign_in create(:user)
      create(:freezer_location)
      visit loads_path
      click_link 'Ship Location'

      expect(page).to have_title 'Shipment Selection'
    end

    it 'displays the name of the location being shipped' do
      sign_in create(:user)
      location = create(:freezer_location)
      visit loads_path
      click_link 'Ship Location'

      expect(page).to have_selector 'h1',
                                    text: 'Shipping location ' + location.name
    end

    it 'has select box for shipments' do
      sign_in create(:user)
      shipment = create(:shipment)
      create(:freezer_location)
      visit loads_path
      click_link 'Ship Location'

      select(shipment.name, from: 'Shipment')
    end

    it 'has submit button' do
      sign_in create(:user)
      shipment = create(:shipment)
      create(:freezer_location)
      visit loads_path
      click_link 'Ship Location'
      select(shipment.name, from: 'Shipment')

      click_button 'Select'
    end
  end
end
