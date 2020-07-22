require 'rails_helper'

RSpec.describe 'Shipping', type: :request do
  describe 'new page' do
    it 'displays the title of the shipment' do
      sign_in create(:user)
      shipment = create(:shipment)
      create(:freezer_location)
      visit loads_path
      click_link 'Ship Location'
      select(shipment.name, from: 'Shipment')
      click_button 'Select'

      expect(page).to have_selector 'h1', text:
                               'Shipping somelocation to ' + shipment.name
    end
  end
end
