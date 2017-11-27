require 'rails_helper'

describe 'Irrigations' do
  describe 'list' do
    it 'has the correct elements' do
      user = create :user
      sign_in user
      field  = create(:field, name: '2', block: create(:block, name: 'B'))
      first  = create(:irrigation, field: field, time: '2017-07-01 08:00')
      second = create(:irrigation, field: field, time: '2017-08-01 14:00')

      visit irrigations_path
      Company.current_id = user.company.id

      expect(page).to have_selector 'title', text: full_title('Irrigations')
      expect(page).to have_selector 'h1', text: 'Current Irrigations'
      expect(page).to have_selector 'td', text: 'B-2'
      expect(page).to have_selector 'td', text: 'July 1, 2017 08:00'
      expect(page).to have_link 'edit', href: edit_irrigation_path(first)
      expect(page.body.index(first.formatted_time))
        .to be > page.body.index(second.formatted_time)
      expect(page).to have_no_xpath("//*[@class='pagination']//a[text()='2']")
    end

    context 'with 31 irrigations' do
      it 'has pagination links' do
        user = create :user
        sign_in user
        field = create :field
        31.times do |n|
          create(:irrigation, field: field, time: Time.current - n.days)
        end

        visit irrigations_path

        find("//*[@class='pagination']//a[text()='2']").click
        expect(page.status_code).to eq(200)
      end
    end

    describe 'form' do
      context 'with invalid data' do
        it 'renders irrigation page with errors' do
          sign_in create(:user)
          visit irrigations_path

          click_button 'Save'

          expect(page).to have_title full_title('Irrigations')
          expect(page).to have_css '.alert-danger'
        end
      end

      context 'with valid data' do
        it 'displays record using american_date' do
          sign_in create(:user)
          create(:field, name: '2', block: create(:block, name: 'B'))
          visit irrigations_path

          select 'B-2', from: 'irrigation_field_id'
          fill_in 'irrigation_time', with: '4/1 14:50'
          click_button 'Save'

          expect(page).to have_selector 'td', text: 'B-2'
          expect(page)
            .to have_selector 'td', text: "April 1, #{Time.current.year} 14:50"
        end
      end

      it 'has js for adding meter readings', js: true do
        user = create :user
        sign_in user
        create(:irrigation_well)
        visit irrigations_path

        fill_in 'irrigation_time', with: '4/1/2013 14:50'
        click_on 'Add Meter Reading'
        fill_in 'Start', with: '123456'
        fill_in 'Stop', with: '654321'

        expect do
          click_button 'Save'
          Company.current_id = user.company.id
        end.to change { MeterReading.count }.by 1
      end
    end
  end

  describe 'edit page' do
    context 'with valid data' do
      it 'updates the irrigation and displays success' do
        sign_in create(:user)
        create(:field, name: 'Field', block: create(:block, name: 'New'))
        visit edit_irrigation_path(create(:irrigation))

        fill_in 'irrigation_time', with: '4/1/2013 2:50pm'
        select  'New-Field', from: 'irrigation_field_id'
        click_button 'Save'

        expect(page).to have_selector 'td', text: 'April 1, 2013 14:50'
        expect(page).to have_css '.alert-success'
      end
    end

    context 'with invalid data' do
      it 'should have error message' do
        sign_in create(:user)
        visit edit_irrigation_path(create(:irrigation))

        fill_in 'irrigation_time', with: ''
        click_button 'Save'

        expect(page).to have_css '.alert-danger'
      end
    end
  end
end
