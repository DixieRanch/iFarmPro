require 'rails_helper'

describe 'Farm' do
  describe 'index page' do
    context 'with an exisiting farm' do
      it 'displays existing farm without new link' do
        sign_in(create(:user))
        farm = Farm.first

        visit farms_path

        expect(page).to have_selector 'title', text: full_title('Farm')
        expect(page).to have_link farm.name, href: farm_path(farm)
        expect(page).not_to have_link('New Farm', href: new_farm_path)
      end
    end
  end

  describe 'show page' do
    it 'displays the farm elements with links' do
      sign_in_new(create(:user))
      field = create :field

      visit farm_path(field.block.farm)

      expect(page).to have_title full_title(field.block.farm.name)
      expect(page).to have_selector 'h1', text: field.block.farm.name
      expect(page).to have_selector 'td', text: field.block.name
      expect(page).to have_selector 'td', text: field.name
      expect(page).to have_selector 'td', text: field.soil_class.name
      expect(page).to have_selector 'td', text: field.acreage
      expect(page).to have_link 'Back to Farms', href: farms_path
      expect(page).to have_link 'Edit', href: edit_farm_path(field.block.farm)
    end
  end

  describe 'new page' do
    it 'has correct page elements' do
      sign_in_new(create(:user))

      visit new_farm_path

      expect(page).to have_title full_title('Add Farm')
      expect(page).to have_selector 'h1', text: 'Add Farm'
    end

    it 'should create a new farm' do
      create :weather_station
      user = create :user
      sign_in_new user
      visit new_farm_path
      fill_in 'Farm Name', with: 'Any Farm'
      select('Fabian Garcia', from: 'Weather Station')

      expect do
        click_button 'Save'
        Company.current_id = user.company.id
      end.to change(Farm, :count).by(1)
    end

    it 'has js to add form fields', js: true do
      create :weather_station
      create :soil_class
      user = create :user
      sign_in_new user
      visit new_farm_path
      Company.current_id = user.company.id
      fill_in 'Farm Name', with: 'Any Farm'
      select('Fabian Garcia', from: 'Weather Station')
      click_on 'Add Irrigation Well'
      fill_in 'Well Name', with: 'Pump 1'
      click_on 'Add Block'
      fill_in 'Block', with: '1'
      click_on 'Add Field'
      fill_in  'Field', with: 'A'
      fill_in 'Acres', with: 7.5
      
      expect do
        click_button 'Save'
        sleep 1
        Company.current_id = user.company.id
      end.to(change { IrrigationWell.count }.by(1)
        .and(change { Block.count }.by(1))
        .and(change { Field.count }.by(1)))
    end

    context 'with invalid data' do
      it 'renders new page with error' do
        sign_in_new create(:user)
        visit new_farm_path

        click_button 'Save'

        expect(page).to have_title full_title('Add Farm')
        expect(page).to have_css '.alert-danger'
      end
    end
  end

  describe 'edit page' do
    it 'displays correct farm and page elements' do
      sign_in_new create :user
      field = create :field

      visit edit_farm_path field.block.farm

      expect(page).to have_title "Edit #{field.block.farm.name}"
      expect(page).to have_selector 'h1', text: "Edit #{field.block.farm.name}"
      expect(page).to have_link 'Cancel', href: farm_path(field.block.farm)
      expect(page).to have_link 'Add Block'
      expect(page).to have_link 'Add Field'
    end

    context 'with invalid information' do
      it 'renders edit page with error' do
        user = create :user
        sign_in_new user
        visit edit_farm_path(create(:field).block.farm)
        fill_in 'Farm Name', with: ''

        click_button 'Save'
        Company.current_id = user.company.id

        expect(page).to have_title full_title('Edit')
        expect(page).to have_css '.alert-danger'
      end
    end

    context 'with valid information' do
      it 'displays the updated attributes' do
        user = create :user
        sign_in user
        create :irrigation_well, farm: user.company.farms.first
        visit edit_farm_path user.company.farms.first
        fill_in 'Farm Name', with: 'NewFarm'
        fill_in 'Block', with: 'NewBlock'
        fill_in 'Field', with: 'NewField'

        click_button 'Save'

        expect(page).to have_title full_title('NewFarm')
        expect(page).to have_css '.alert-success', text: 'Updated'
        expect(page).to have_content 'NewFarm'
        expect(page).to have_content 'NewBlock'
        expect(page).to have_content 'NewField'
      end
    end
  end
end
