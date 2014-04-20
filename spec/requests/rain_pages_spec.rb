require 'spec_helper'

describe 'Rain' do

  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    visit rains_path
    sign_in(user)
    Company.current_id = user.company.id
  end

  describe 'index page' do

    let(:rain) { FactoryGirl.create(:rain) }
    let(:amount) { rain.amount }
    let(:date) { rain.date }

    # it { expect(current_path).to eq(rains_path) }
    describe 'GET rain path' do
      it 'renders the rain index view' do
        expect(current_path).to eq(rains_path)
      end
    end

    describe 'page detail' do

      it 'displays header' do
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

      it 'populates Amount column' do
        pending 'TODO'
        expect(page).to have_selector 'table#rain_table tbody tr td', text: amount
      end

      it 'populates Date column' do
        pending 'TODO'
        expect(page).to have_selector 'table#rain_table tbody tr td', text: date
      end

    end

  end

end