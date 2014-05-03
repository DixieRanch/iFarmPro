require 'spec_helper'

describe 'Irrigation' do

  let(:user) { FactoryGirl.create(:user) }
  subject { page }

  before do
    sign_in(user)
    Company.current_id = user.company.id
  end

  describe 'index page' do

    describe 'previous irrigations list' do
      let!(:irrigation) { FactoryGirl.create(:irrigation) }
      let!(:new_irrigation) do
        FactoryGirl.create(:irrigation, time: irrigation.time + 1.day)
      end
      let(:field_name) { irrigation.field.name_with_block }
      let(:time) { new_irrigation.time.to_s(:long) }

      before { visit irrigations_path }
        
      it { should have_selector 'title', text: full_title('Irrigations') }
      it { should have_selector 'h1', text: 'Current Irrigations' }
      it { should have_selector 'td', text: field_name }
      it { should have_selector 'td', text: irrigation.time.to_s(:long) }
      it { should have_link 'edit', href: edit_irrigation_path(irrigation) }
      it 'should have the correct sort order' do
        first_irrigation = page.body.index(irrigation.time.to_s(:long))
        second_irrigation = page.body.index(new_irrigation.time.to_s(:long))
        expect(second_irrigation).to be < first_irrigation
      end
      it 'should have a link to the edit page' do
        Company.current_id = user.company.id
        click_link 'edit'
        expect(page).to have_field 'irrigation[time]', with: time
      end
    end

    describe 'new irrigation form' do
      let!(:block) { FactoryGirl.create(:block) }
      let!(:field) { FactoryGirl.create(:field, block: block) }

      before do
        
      end

      context 'with invalid data' do
        before do
          visit irrigations_path
          Company.current_id = user.company.id
          click_button 'Save'
        end

        it { should have_selector 'title', text: full_title('Irrigations') }
        it { should have_css '.alert-error' }
      end

      context 'with valid data' do

        before do
          block = FactoryGirl.create(:block, name: '1')
          FactoryGirl.create(:field, name: '1', block: block)
          visit irrigations_path
          select('1-1', from: 'irrigation_field_id')
          fill_in 'irrigation_time', with: '4/1/2013 14:50'
          click_button 'Save'
        end

        it { should have_selector 'td', text: '1-1' }
        it 'should parse using american_date' do
          expect(page).to have_selector 'td', text: 'April 01, 2013 14:50'
        end

      end

      it "has js for adding meter readings", js: true do
        FactoryGirl.create(:irrigation_well)
        init_meter_count = MeterReading.count
        visit irrigations_path
        fill_in 'irrigation_time', with: '4/1/2013 14:50'
        click_on 'Add Meter Reading'
        fill_in 'Start', with: '123456'
        fill_in 'Stop', with: '654321'
        click_button 'Save'
        Company.current_id = user.company.id
        expect(MeterReading.count).to be > init_meter_count
      end
    end
  end

  describe 'edit page' do
    let(:irrigation) { FactoryGirl.create(:irrigation) }
    let!(:meter_reading) { FactoryGirl.create(:meter_reading) }
    let(:time) { '4/1/2013 14:50' }
    before do      
      visit edit_irrigation_path(irrigation)
      Company.current_id = user.company.id
    end

    context 'with valid data' do

      it 'should update the irrigation' do
        fill_in 'irrigation_time', with: time
        click_button 'Save'
        expect(page).to have_selector 'td', text: time.to_time.to_s(:long)
      end

      it 'should display a success message' do
        click_button 'Save'
        expect(page).to have_css '.alert-success'
      end
    end

    context 'with invalid data' do

      it 'should have error message' do
        fill_in 'irrigation_time', with: ''
        click_button 'Save'
        expect(page).to have_css '.alert-error'
      end
    end
  end 
end