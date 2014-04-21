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
    let(:date) { rain.date.strftime('%m/%d/%Y') }

    let!(:rain_yesterday) { FactoryGirl.create(:rain, amount: 5.75, date: Date.yesterday) }
    let(:amount_yesterday) { rain_yesterday.amount.to_s }
    let(:date_yesterday) { rain_yesterday.date.strftime('%m/%d/%Y') }

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
        expect(page).to have_selector 'table#rain_table tbody tr td#amount_0', text: amount_yesterday
      end

      it 'populates 2nd row Amount' do
        expect(page).to have_selector 'table#rain_table tbody tr td#amount_1', text: amount
      end

      it 'populates 1st row Date' do
        expect(page).to have_selector 'table#rain_table tbody tr td#date_0', text: date_yesterday
      end

      it 'populates 2nd row Date' do
        expect(page).to have_selector 'table#rain_table tbody tr td#date_1', text: date
      end

      it 'edit link/button row 1' do
        find('#link_0', text: 'Edit').should have_content 'Edit'
      end

      it 'edit link/button row 2' do
        find('#link_1', text: 'Edit').should have_content 'Edit'
      end

      it 'click edit link' do
        Company.current_id = user.company.id
        page.find('#link_0').click
        expect(current_path).to eq(edit_rain_path(rain_yesterday))
      end

      it 'edit link header' do
        expect(page).to have_selector 'h1', text: 'Current Rain'
      end

    end

  end

end