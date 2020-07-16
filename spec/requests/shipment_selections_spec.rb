require 'rails_helper'

RSpec.describe 'ShipmentSelections', type: :request do
  describe 'new page' do
    it 'has correct title' do
      sign_in create(:user)
      visit new_shipment_selection_path

      expect(page).to have_title 'Shipment Selection'
    end
  end
end
