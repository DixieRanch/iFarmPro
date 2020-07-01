require 'rails_helper'

RSpec.describe 'Shipments', type: :request do
  describe 'page' do
    it 'has correct title' do
      sign_in create(:user)
      visit shipments_path

      expect(page).to have_selector 'h1', text: 'Shipment Overview'
    end

    it 'displays created shipments' do
      sign_in create(:user)
      shipment = create(:shipment)
      visit shipments_path

      expect(page).to have_selector 'td', text: shipment.name
      expect(page).to have_selector 'td', text: shipment.date
      expect(page).to have_selector 'td', text: shipment.destination
    end
  end
end
