require 'rails_helper'

describe 'Irrigation' do
  let(:user) { create(:user) }
  subject { page }

  before do
    sign_in(user)
  end

  describe 'index page' do
    describe 'previous irrigations list', slow: true do
      let!(:irrigation) { create(:irrigation) }
      let!(:new_irrigation) do
        create(:irrigation, time: irrigation.time + 1.day)
      end
      let(:field_name) { irrigation.field.name_with_block }
      let(:time) { new_irrigation.formatted_time }

      before do
        28.times { create(:irrigation) } # Total of 30 Irrigation Records
        visit irrigations_path
      end

      it 'has the correct elements' do
        expect(page).to have_selector 'title', text: full_title('Irrigations')
        expect(page).to have_selector 'h1', text: 'Current Irrigations'
        expect(page).to have_selector 'td', text: field_name
        expect(page).to have_selector 'td', text: irrigation.formatted_time
        expect(page).to have_link 'edit', href: edit_irrigation_path(irrigation)
        first_irrigation = page.body.index(irrigation.formatted_time)
        second_irrigation = page.body.index(new_irrigation.formatted_time)
        expect(second_irrigation).to be < first_irrigation
        click_link 'edit'
        expect(page).to have_field 'irrigation[time]', with: time
        expect(page).to have_no_xpath("//*[@class='pagination']//a[text()='2']")
      end

      context 'with 31 irrigations' do
        before do
          Company.current_id = user.company.id
          create(:irrigation)
          visit irrigations_path
        end

        it 'has pagination links' do
          find("//*[@class='pagination']//a[text()='2']").click
          expect(page.status_code).to eq(200)
        end
      end
    end

    describe 'new irrigation form' do
      let!(:block) { create(:block) }
      let!(:field) { create(:field, block: block) }

      before do
      end

      context 'with invalid data' do
        before do
          visit irrigations_path
          click_button 'Save'
        end

        it 'renders irrigation page with error' do
          expect(page).to have_title full_title('Irrigations')
          expect(page).to have_css '.alert-danger'
        end
      end

      context 'with valid data' do
        before do
          create(:field, name: '1', block: create(:block, name: '1'))
          visit irrigations_path
          select('1-1', from: 'irrigation_field_id')
          fill_in 'irrigation_time', with: '4/1 14:50'
          click_button 'Save'
        end

        it 'displays record using american_date' do
          expect(page).to have_selector 'td', text: '1-1'
          year = Time.now.year
          expect(page).to have_selector 'td', text: "April 1, #{year} 14:50"
        end
      end

      it 'has js for adding meter readings', js: true, slow: true do
        create(:irrigation_well)
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
    let(:irrigation) { create(:irrigation) }
    let!(:meter_reading) { create(:meter_reading) }
    let(:time) { '4/1/2013 14:50' }
    before do
      create(:field, name: 'One', block: create(:block, name: 'This'))
      visit edit_irrigation_path(irrigation)
    end

    context 'with valid data', slow: true do
      it 'updates the irrigation and displays success' do
        fill_in 'irrigation_time', with: time
        select('This-One', from: 'irrigation_field_id')
        click_button 'Save'
        expect(page).to have_selector 'td', text: 'April 1, 2013 14:50'
        expect(page).to have_css '.alert-success'
      end
    end

    context 'with invalid data' do
      it 'should have error message' do
        fill_in 'irrigation_time', with: ''
        click_button 'Save'
        expect(page).to have_css '.alert-danger'
      end
    end
  end
end
