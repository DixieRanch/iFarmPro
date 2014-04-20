require 'spec_helper'

describe 'Rain' do

  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    sign_in(user)
  end

  describe 'index page' do

    before(:each) do
      visit rains_path
      Company.current_id = user.company.id
      # FactoryGirl.create(:rain)
      # @rain = Rain.all
    end

    let(:rain) { FactoryGirl.create(:rain) }
    let(:amount) { rain.amount.to_s }
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
        #save_and_open_page
      end

      it 'populates Amount column via instance variable' do
        pending 'TODO'
        # @rain.each do |rain|
        #   puts "company_id: #{rain.company_id} amount: #{rain.amount} date: #{rain.date}"
        # end
        expect(page).to have_selector 'table#rain_table tbody tr td', text: @rain[0].amount.to_s
      end

      # it 'populates Amount column' do
      #   #pending 'TODO'
      #   @rain.each do |rain|
      #     puts "company_id: #{rain.company_id} amount: #{rain.amount} date: #{rain.date}"
      #   end
      #   expect(page).to have_selector 'table#rain_table tbody tr td', text: amount
      # end
      #
      # it 'populates Date column' do
      #   pending 'TODO'
      #   expect(page).to have_selector 'table#rain_table tbody tr td', text: date
      # end
      #
      # it 'test for content' do
      #   expect(page).to have_content('0.75')
      # end
      #
      # it 'Nothing to see here' do
      #   expect(page).to have_selector 'h2', text: 'Nothing to see here'
      # end

    end

  end

end