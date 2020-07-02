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

      expect(page).to have_selector 'h1', text: 'New Shipment'
    end

    it 'has name text field' do
      sign_in create(:user)
      visit new_shipment_path

      fill_in('Shipment Name', with: 'Shipment1')
    end

    it 'has a date input' do
      sign_in create(:user)
      visit new_shipment_path

      select('2020', from: 'shipment_date_1i')
      select('August', from: 'shipment_date_2i')
      select('25', from: 'shipment_date_3i')
    end

    it 'has a destination text field' do
      sign_in create(:user)
      visit new_shipment_path

      fill_in('Destination', with: 'Sheller')
    end

    it 'has a submit button' do
      sign_in create(:user)
      visit new_shipment_path

      click_button 'Save'
    end

    context 'when submitting valid shipment data' do
      it 'adds the shipment to the database' do
        sign_in(user = create(:user))
        visit new_shipment_path

        fill_in('Shipment Name', with: 'Shipment1')

        select('2020', from: 'shipment_date_1i')
        select('August', from: 'shipment_date_2i')
        select('25', from: 'shipment_date_3i')

        fill_in('Destination', with: 'Sheller')

        expect do
          click_button 'Save'
          Company.current_id = user.company_id
        end.to(change { Shipment.count }.by(1))
      end

      it 'flashes a success message' do
        sign_in create(:user)
        visit new_shipment_path

        fill_in('Shipment Name', with: 'Shipment1')

        select('2020', from: 'shipment_date_1i')
        select('August', from: 'shipment_date_2i')
        select('25', from: 'shipment_date_3i')

        fill_in('Destination', with: 'Sheller')
        click_button 'Save'

        expect(page).to have_css '.alert-success'
      end
    end
  end
end
