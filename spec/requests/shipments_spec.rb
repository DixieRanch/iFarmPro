require 'rails_helper'

RSpec.describe 'Shipments', type: :request do
  describe 'new page' do
    it 'has correct title' do
      sign_in create(:user)
      visit new_shipment_path

      expect(page).to have_selector 'h1', text: 'Shipments'
    end

    it 'displays created shipments' do
      sign_in create(:user)
      shipment = create(:shipment)
      visit new_shipment_path

      expect(page).to have_selector 'td', text: shipment.name
      expect(page).to have_selector 'td', text: shipment.date
      expect(page).to have_selector 'td', text: shipment.destination
    end
  end

  describe 'edit link' do
    context 'when clicked' do
      it 'renders the edit shipment page' do
        sign_in create(:user)
        create(:shipment)
        visit new_shipment_path

        click_link 'edit'

        expect(page).to have_title full_title 'Shipments'
      end
    end
  end

  describe 'edit form' do
    it 'displays the correct shipment name' do
      sign_in create(:user)
      shipment = create(:shipment)
      visit new_shipment_path

      click_link 'edit'

      expect(page).to have_field('Shipment Name', with: shipment.name)
    end

    context 'when submitting valid edits' do
      it 'updates the record' do
        sign_in create(:user)
        create(:shipment, name: 'shipment1')
        visit new_shipment_path
        click_link 'edit'

        fill_in('Shipment Name', with: 'shipment2')
        click_button 'Save'

        expect(page).to have_selector 'td', text: 'shipment2'
        expect(page).to_not have_selector 'td', text: 'shipment1'
      end

      it 'flashes a success message' do
        sign_in create(:user)
        create(:shipment)
        visit new_shipment_path
        click_link 'edit'

        click_button 'Save'

        expect(page).to have_css '.alert-success'
      end
    end

    context 'when submitting invalid edits' do
      it 'indicates there is an error' do
        sign_in create(:user)
        create(:shipment)
        visit new_shipment_path
        click_link 'edit'

        fill_in('Shipment Name', with: '')
        click_button 'Save'

        expect(page).to have_css('div.has-error')
      end
    end
  end

  describe 'new form' do
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
      it 'adds a shipment to the database' do
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

    context 'when submitting a blank form' do
      it 'rerenders the page with correct title' do
        sign_in create(:user)
        visit new_shipment_path

        click_button 'Save'

        expect(page).to have_title full_title 'Shipments'
      end

      it 'indicates field with error' do
        sign_in create(:user)
        visit new_shipment_path

        click_button 'Save'

        expect(page).to have_css('div.has-error')
      end
    end
  end
end
