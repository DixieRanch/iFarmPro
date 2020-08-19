require 'rails_helper'

RSpec.describe 'ShipmentManifests', type: :request do
  describe 'show page' do
    it 'has correct title' do
      sign_in create(:user)
      shipment = create(:shipment)
      visit shipment_manifest_path(shipment.id)

      expect(page).to have_selector 'h1', text:
                                           shipment.name.to_s + ' Manifest'
    end

    it 'displays the names of shipped lots' do
      sign_in create(:user)
      shipment = create(:shipment)
      lot1 = create(:lot, shipment_id: shipment.id, freezer_location_id: nil)
      lot2 = create(:lot, shipment_id: shipment.id, freezer_location_id: nil)
      visit shipment_manifest_path(shipment.id)

      expect(page).to have_selector 'td', text: lot1.name
      expect(page).to have_selector 'td', text: lot2.name
    end

    it 'displays the box names of shipped lots' do
      sign_in create(:user)
      shipment = create(:shipment)
      lot1 = create(:lot, shipment_id: shipment.id, freezer_location_id: nil)
      lot2 = create(:lot, shipment_id: shipment.id, freezer_location_id: nil)
      visit shipment_manifest_path(shipment.id)

      expect(page).to have_selector 'td', text: lot1.box.name
      expect(page).to have_selector 'td', text: lot2.box.name
    end

    it 'has link to remove lot from shipment' do
      sign_in create(:user)
      shipment = create(:shipment)
      create(:lot, shipment_id: shipment.id, freezer_location_id: nil)
      visit shipment_manifest_path(shipment.id)

      click_link 'remove'
    end
  end

  describe 'edit page' do
    it 'has correct title' do
      sign_in create(:user)
      shipment = create(:shipment)
      lot = create(:lot, shipment_id: shipment.id, freezer_location_id: nil)
      visit edit_shipment_manifest_path(lot.id)

      expect(page).to have_selector 'h1', text:
                                    'Return ' + lot.name.to_s + ' to Storage'
    end

    it 'has form to select destination location' do
      sign_in create(:user)
      shipment = create(:shipment)
      lot = create(:lot, shipment_id: shipment.id, freezer_location_id: nil)
      location = create(:freezer_location)
      visit edit_shipment_manifest_path(lot.id)

      select(location.name, from: 'Location')
    end

    it 'has select button' do
      sign_in create(:user)
      shipment = create(:shipment)
      lot = create(:lot, shipment_id: shipment.id, freezer_location_id: nil)
      location = create(:freezer_location)
      visit edit_shipment_manifest_path(lot.id)

      select(location.name, from: 'Location')
      click_button 'Move Lot'
    end

    it 'updates the lot location' do
      sign_in create(:user)
      shipment = create(:shipment)
      lot = create(:lot, shipment_id: shipment.id, freezer_location_id: nil)
      location = create(:freezer_location)
      visit edit_shipment_manifest_path(lot.id)

      select(location.name, from: 'Location')
      click_button 'Move Lot'

      lot.reload
      expect(lot.freezer_location_id).to eq location.id
    end
  end
end
