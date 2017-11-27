require 'rails_helper'

describe 'Rains' do
  describe 'list' do
    it 'has table for rains' do
      sign_in create :user
      rain = create(:rain, amount: 0.17, date: '7/1/2017')

      visit rains_path

      expect(page).to have_title full_title 'Rain'
      expect(page).to have_selector 'h1', text: 'Current Rain'
      expect(page).to have_selector 'thead', text: 'Amount'
      expect(page).to have_selector 'thead', text: 'Date'
      expect(page).to have_selector 'tbody', text: '0.17'
      expect(page).to have_selector 'tbody', text: 'July 1, 2017'
      expect(page).to have_link 'Edit', href: edit_rain_path(rain)
    end

    it 'is ordered from latest to earliest' do
      sign_in create :user
      earliest = create(:rain, date: '2017-07-01').formatted_date
      latest = create(:rain, date: '2017-08-01').formatted_date

      visit rains_path

      expect(page.body.index(latest)).to be < page.body.index(earliest)
    end

    context 'with 31 rains' do
      it 'has pagination links' do
        sign_in create :user
        farm = create :farm
        31.times { |n| create(:rain, farm: farm, date: Time.current - n.days) }

        visit rains_path

        expect(page).to have_selector 'table#rain_table tbody tr', count: 30
        expect(page).to have_link '2', href: rains_path(page: 2)
      end
    end
  end

  describe 'form' do
    context 'with valid input' do
      it 'displays new rain record' do
        sign_in create :user
        visit rains_path

        fill_in 'Date', with: '5/31/2014'
        fill_in 'Amount', with: 1.75
        click_button 'Save'

        expect(page).to have_selector 'td', text: '1.75'
        expect(page).to have_selector 'td', text: 'May 31, 2014'
      end
    end

    context 'with invalid input' do
      it 'renders rain page with errors' do
        sign_in create :user
        visit rains_path

        fill_in 'rain_amount', with: -23
        fill_in 'rain_date', with: 'abc'
        click_button 'Save'

        expect(page).to have_css '.alert-danger'
      end
    end
  end

  describe 'edit page' do
    it 'has correct elements' do
      sign_in create :user
      rain = create :rain

      visit edit_rain_path(rain)

      expect(page).to have_field 'rain_amount', with: rain.amount.to_s
      expect(page).to have_field 'rain_date', with: rain.formatted_date
    end

    context 'with valid data' do
      it 'update rain' do
        sign_in create :user
        rain = create(:rain, date: '2017-07-01', amount: 0.25)
        visit edit_rain_path(rain)

        fill_in 'rain_amount', with: '1.5'
        fill_in 'rain_date', with: '8/15/2017'
        click_button 'Save'

        expect(page).to have_selector 'tbody', text: '1.5'
        expect(page).to have_selector 'tbody', text: 'August 15, 2017'
      end
    end
  end
end
