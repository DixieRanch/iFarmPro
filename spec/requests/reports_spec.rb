require 'rails_helper'

describe 'ReportPages' do
  context 'for Next Irrigations' do
    it 'has correct elements' do
      sign_in create(:user)

      visit report_path(:next_irrigations)

      expect(page).to have_title full_title('Schedule')
      expect(page).to have_selector 'h1', text: 'Irrigation Schedule'
    end

    context 'with data' do
      it 'displays irrigation report' do
        sign_in create(:user)
        field = create(:field, name: '2', block: create(:block, name: 'B'))
        create(:irrigation, field: field, time: '2017-07-01 13:00')

        visit report_path(:next_irrigations)

        expect(page).to have_selector 'td', text: 'B-2'
        expect(page).to have_selector 'td', text: 'July 1, 2017'
        expect(page).to have_selector 'td', text: 'July 15, 2017'
      end
    end
  end

  context 'for Fertilizer' do
    it 'has correct elements' do
      sign_in create(:user)

      visit report_path(:fertilizer)

      expect(page).to have_title full_title('Nutrition')
      expect(page).to have_selector 'h1', text: 'Nutrition Report'
    end

    context 'with data' do
      it 'displays fertilizer report' do
        sign_in create(:user)
        units = create(:soil_application_unit, name: 'Gal', density: 11)
        product = create(:soil_product, n: 16, p: 8, k: 3, s: 4)
        field = create(:field, name: '2',
                               acreage: 7,
                               block: create(:block, name: 'B'))
        create(:soil_application, quantity: 150,
                                  soil_application_unit: units,
                                  soil_product: product,
                                  field: field)

        visit report_path(:fertilizer)

        expect(page).to have_selector 'td', text: 'B-2'
        expect(page).to have_selector(
          'td', text: (150 * 11 * 0.16 / 7).round.to_s
        )
        expect(page).to have_selector(
          'td', text: (150 * 11 * 0.08 / 7).round.to_s
        )
        expect(page).to have_selector(
          'td', text: (150 * 11 * 0.03 / 7).round.to_s
        )
        expect(page).to have_selector(
          'td', text: (150 * 11 * 0.04 / 7).round.to_s
        )
      end
    end
  end
  
  context 'for Next Herbicide Applications' do
    it 'has correct elements' do
      sign_in create(:user)
      
      visit report_path(:next_herbicide_applications)
      
      expect(page).to have_title full_title('Spray Schedule')
      expect(page).to have_selector 'h1', text: 'Spray Schedule'
    end
  end
end
