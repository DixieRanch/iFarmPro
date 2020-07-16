require 'rails_helper'

RSpec.describe 'ShipmentSelections', type: :request do
  describe 'new page' do
    it 'has correct title' do
      sign_in create(:user)
      visit new_shipment_selection_path

      expect(page).to have_title 'Shipment Selection'
    end

    it 'has select box for shipments' do
      sign_in create(:user)
      shipment = create(:shipment)
      visit new_shipment_selection_path

      select(shipment.name, from: 'Shipment')
    end
  end
end
