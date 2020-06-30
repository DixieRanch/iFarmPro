require 'rails_helper'

RSpec.describe 'Shipments', type: :request do
  describe 'shipments page' do
    it 'has correct title' do
        sign_in create(:user)
        visit shipments_path
        
        expect(page).to have_selector 'h1', text: 'Shipment Overview'
    end
  end
end
