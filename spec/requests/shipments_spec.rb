require 'rails_helper'

RSpec.describe 'Shipments', type: :request do
  describe 'overview page' do
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
  
  describe 'new page' do
    it 'has correct title' do
      sign_in create(:user)
      visit new_shipment_path
      
      expect(page).to have_selector 'h1', text: "New Shipment"
    end
    
    it 'has name text field' do
      sign_in create(:user)
      visit new_shipment_path
      
      fill_in('Shipment Name', with: 'Shipment1')
    end
  end
end
