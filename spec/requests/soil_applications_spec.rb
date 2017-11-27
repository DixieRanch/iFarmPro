require 'rails_helper'

describe 'SoilApplications' do
  describe 'list' do
    it 'has correct elements' do
      sign_in create(:user)

      visit soil_applications_path

      expect(page).to have_title full_title 'Soil Applications'
      expect(page).to have_selector 'h1', text: 'Current Applications'
    end

    it 'displays soil applications' do
      sign_in create(:user)
      field = create(:field, name: '2', block: create(:block, name: 'B'))
      product  = create(:soil_product, name: 'Some Fertilizer')
      soil_app = create(:soil_application, date: '2017-07-01',
                                           quantity: 200,
                                           field: field,
                                           soil_product: product)

      visit soil_applications_path

      expect(page).to have_selector 'td', text: 'July 1, 2017'
      expect(page).to have_selector 'td', text: 'B-2'
      expect(page).to have_selector 'td', text: 'Some Fertilizer'
      expect(page).to have_selector 'td', text: '200'
      expect(page).to have_link     'edit',
                                    href: edit_soil_application_path(soil_app)
    end

    context 'with 31 applications' do
      it 'has pagination links' do
        sign_in_new create(:user)
        field = create(:field)
        product = create(:soil_product)
        units = create(:soil_application_unit)
        31.times do
          create(:soil_application, field: field,
                                    soil_product: product,
                                    soil_application_unit: units)
        end

        visit soil_applications_path

        expect(page).to have_selector 'tbody tr', count: 30

        click_link '2'

        expect(page).to have_selector 'tbody tr', count: 1
        expect(page).to have_selector 'em.current', text: 2
      end
    end
  end

  describe 'form' do
    context 'with invalid data' do
      it 'renders Soil App page with error' do
        sign_in create(:user)
        visit soil_applications_path

        click_button 'Save'

        expect(page).to have_title full_title 'Soil Applications'
        expect(page).to have_css '.alert-danger'
      end
    end

    context 'with valid data' do
      it 'displays the new record with success' do
        sign_in create(:user)
        create(:soil_product)
        create(:soil_application_unit)
        visit soil_applications_path

        fill_in 'Date',     with: '2017-4-1'
        fill_in 'Quantity', with: 123
        click_button 'Save'

        expect(page).to have_selector 'td', text: 'April 1, 2017'
        expect(page).to have_selector 'td', text: '123'
        expect(page).to have_css '.alert-success'
      end
    end
  end

  describe 'edit page' do
    context 'with invalid data' do
      it 'has error message' do
        sign_in_new create(:user)
        create :soil_application
        visit soil_applications_path

        fill_in 'Quantity', with: ''
        click_button 'Save'

        expect(page).to have_css '.alert-danger'
      end
    end

    context 'with valid data' do
      it 'updates soil application with success' do
        sign_in_new create(:user)
        create(:field, name: 'One', block: create(:block, name: 'This'))
        visit edit_soil_application_path(create(:soil_application))

        fill_in 'Date', with: '1/4/2017'
        select('This-One', from: 'soil_application_field_id')
        click_button 'Save'

        expect(page).to have_selector 'td', text: 'January 4, 2017'
        expect(page).to have_selector 'td', text: 'This-One'
        expect(page).to have_css '.alert-success'
      end
    end
  end
end
