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
  end
end
