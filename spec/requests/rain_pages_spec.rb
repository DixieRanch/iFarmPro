require 'spec_helper'

describe 'Rain' do

  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    sign_in(user)
    Company.current_id = user.company.id
  end

  describe 'index page' do

    let!(:rain) { FactoryGirl.create(:rain) }
    let(:amount) { rain.amount.to_s }
    let(:date) { rain.formatted_date }

    let!(:rain_yesterday) { FactoryGirl.create(:rain, amount: 5.75, date: Date.yesterday) }
    let(:amount_yesterday) { rain_yesterday.amount.to_s }
    let(:date_yesterday) { rain_yesterday.formatted_date }

    before(:each) do
      visit rains_path
    end

    #it { expect(current_path).to eq(rains_path) }
    describe 'GET rain path' do
      it 'renders the rain index view' do
        expect(current_path).to eq(rains_path)
      end
    end

    describe 'page detail' do

      it "has correct elements" do
        expect(page).to have_selector 'h1', text: 'Current Rain'
        expect(page).to have_title full_title('Rain')
        expect(page).to have_selector 'table#rain_table'
        expect(page).to have_selector 'table#rain_table thead tr th', text: 'Amount'
        expect(page).to have_selector 'table#rain_table thead tr th', text: 'Date'
        page.should have_selector 'table#rain_table tbody tr', :count => 2
        expect(page).to have_selector 'table#rain_table tbody tr td#amount_1', text: amount_yesterday
        expect(page).to have_selector 'table#rain_table tbody tr td#amount_0', text: amount
        expect(page).to have_selector 'table#rain_table tbody tr td#date_1', text: date_yesterday
        expect(page).to have_selector 'table#rain_table tbody tr td#date_0', text: date
        find('#link_0', text: 'Edit').should have_content 'Edit'
        find('#link_1', text: 'Edit').should have_content 'Edit'
        expect(page).to have_selector 'h1', text: 'Current Rain'
        expect(page).to have_field 'rain_amount'
        expect(page).to have_field 'rain_date'
        expect(page).to have_button('Save')        
      end

      it 'click edit link' do
        Company.current_id = user.company.id
        page.find('#link_1').click
        expect(current_path).to eq(edit_rain_path(rain_yesterday))
      end


      context 'create with valid data' do

        let!(:rain_tomorrow) { Rain.new(amount: 2.88888, date: Date.tomorrow) }
        let(:amount_tomorrow) { rain_tomorrow.amount.to_s }
        let(:date_tomorrow) { rain_tomorrow.formatted_date }

        it 'create rain' do
          fill_in 'rain_amount', with: amount_tomorrow
          fill_in 'rain_date', with: date_tomorrow
          click_button 'Save'
          expect(page).to have_selector 'td', text: amount_tomorrow
          expect(page).to have_selector 'td', text: date_tomorrow
        end
      end

      context 'create with invalid data' do

        it 'create rain' do
          fill_in 'rain_amount', with: -23
          fill_in 'rain_date', with: 'abc'
          click_button 'Save'
          expect(page).to have_css '.alert-error'
        end
      end
    end
  end

  describe 'edit page' do

    let!(:rain) { FactoryGirl.create(:rain) }
    let(:amount) { rain.amount.to_s }
    let(:date) { rain.formatted_date }

    before(:each) do
      visit edit_rain_path(rain)
      Company.current_id = user.company.id
    end

    it "has correct elements" do
      expect(current_path).to eq(edit_rain_path(rain))
      expect(page).to have_field 'rain_amount'
      expect(page).to have_field 'rain_date'
      expect(page).to have_button('Save')
    end

    context 'with valid data' do

      let!(:rain_update) { Rain.new(amount: 7.777, date: 3.day.from_now) }
      let(:amount_update) { rain_update.amount.to_s }
      let(:date_update) { rain_update.formatted_date }

      it 'update rain' do
        click_link 'link_0'
        fill_in 'rain_amount', with: amount_update
        fill_in 'rain_date', with: date_update
        click_button 'Save'
        expect(page).to have_selector 'table#rain_table tbody tr td#amount_0', text: amount_update
        expect(page).to have_selector 'table#rain_table tbody tr td#date_0', text: date_update

        #element = find_by_id('amount_0')
        #puts "element: #{element.text}"
      end
    end
  end
end