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

      it 'index header' do
        expect(page).to have_selector 'h1', text: 'Current Rain'
      end

      it 'populates title' do
        expect(page).to have_title full_title('Rain')
      end

      it 'should have rain table' do
        expect(page).to have_selector 'table#rain_table'
      end

      it 'rain table should have Amount column' do
        expect(page).to have_selector 'table#rain_table thead tr th', text: 'Amount'
      end

      it 'rain table should have Date column' do
        expect(page).to have_selector 'table#rain_table thead tr th', text: 'Date'
      end

      it 'table length' do
        page.should have_selector 'table#rain_table tbody tr', :count => 2
      end

      it 'populates 1st row Amount' do
        expect(page).to have_selector 'table#rain_table tbody tr td#amount_1', text: amount_yesterday
      end

      it 'populates 2nd row Amount' do
        expect(page).to have_selector 'table#rain_table tbody tr td#amount_0', text: amount
      end

      it 'populates 1st row Date' do
        expect(page).to have_selector 'table#rain_table tbody tr td#date_1', text: date_yesterday
      end

      it 'populates 2nd row Date' do
        expect(page).to have_selector 'table#rain_table tbody tr td#date_0', text: date
      end

      it 'edit link/button row 1' do
        find('#link_0', text: 'Edit').should have_content 'Edit'
      end

      it 'edit link/button row 2' do
        find('#link_1', text: 'Edit').should have_content 'Edit'
      end

      it 'click edit link' do
        Company.current_id = user.company.id
        page.find('#link_1').click
        expect(current_path).to eq(edit_rain_path(rain_yesterday))
      end

      it 'edit link header' do
        expect(page).to have_selector 'h1', text: 'Current Rain'
      end

      it 'amount field' do
        expect(page).to have_field 'rain_amount'
      end

      it 'date field' do
        expect(page).to have_field 'rain_date'
      end

      it 'submit button' do
        expect(page).to have_button('rain_submit')
      end

      context 'create with valid data' do

        let!(:rain_tomorrow) { Rain.new(amount: 2.88888, date: Date.tomorrow) }
        let(:amount_tomorrow) { rain_tomorrow.amount.to_s }
        let(:date_tomorrow) { rain_tomorrow.formatted_date }

        it 'create rain' do
          fill_in 'rain_amount', with: amount_tomorrow
          fill_in 'rain_date', with: date_tomorrow
          click_button 'Create Rain'

          # alternate ways to test
          #expect(page).to have_content(amount_tomorrow)
          #expect(page).to have_content(date_tomorrow)
          #find_by_id('amount_0')
          #find_by_id('date_0')

          expect(page).to have_selector 'table#rain_table tbody tr td#amount_0', text: amount_tomorrow
          expect(page).to have_selector 'table#rain_table tbody tr td#date_0', text: date_tomorrow

          # this fails - why?
          #expect(page).to have_field 'amount_0', with: amount_tomorrow
        end
        #save_and_open_page

      end

      context 'create with invalid data' do

        it 'create rain' do
          fill_in 'rain_amount', with: -23
          fill_in 'rain_date', with: 'abc'
          click_button 'Create Rain'
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

    describe 'GET edit rain path' do
      it 'renders the rain edit view' do
        expect(current_path).to eq(edit_rain_path(rain))
      end
    end

    describe 'page detail' do

      it 'amount field' do
        expect(page).to have_field 'rain_amount'
      end

      it 'date field' do
        expect(page).to have_field 'rain_date'
      end

      it 'submit button' do
        expect(page).to have_button('rain_submit')
      end

      #save_and_open_page

    end

    context 'with valid data' do

      let!(:rain_update) { Rain.new(amount: 7.777, date: 3.day.from_now) }
      let(:amount_update) { rain_update.amount.to_s }
      let(:date_update) { rain_update.formatted_date }

      it 'update rain' do
        click_link 'link_0'
        fill_in 'rain_amount', with: amount_update
        fill_in 'rain_date', with: date_update
        click_button 'Update Rain'
        expect(page).to have_selector 'table#rain_table tbody tr td#amount_0', text: amount_update
        expect(page).to have_selector 'table#rain_table tbody tr td#date_0', text: date_update

        #element = find_by_id('amount_0')
        #puts "element: #{element.text}"
      end

    end

  end

end