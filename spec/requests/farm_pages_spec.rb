require 'spec_helper'

describe "Farm" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in_new(user)
    Company.current_id = user.company.id
  end

  describe "index page" do

    context "with an exisiting farm" do

      # let!(:farm) { FactoryGirl.create(:farm) }

      before do
        create(:field)
        @farm = Farm.first
        visit farms_path
      end

      it "displays existing farm without new link" do
        expect(page).to have_selector 'title', text: full_title('Farm')
        expect(page).to have_link @farm.name, href: farm_path(@farm)
        expect(page).not_to have_link('New Farm', href: new_farm_path)
      end

    end
  end

  describe "show page" do
    let!(:farm) { FactoryGirl.create(:farm) }
    let!(:block) { FactoryGirl.create(:block, farm: farm) }
    let!(:field) { FactoryGirl.create(:field, block: block) }

    before { visit farm_path(farm) }

    it "displays the farm elements with links" do
      expect(page).to have_title full_title(farm.name)
      expect(page).to have_selector 'h1', text: farm.name
      expect(page).to have_selector 'td', text: block.name
      expect(page).to have_selector 'td', text: field.name
      expect(page).to have_selector 'td', text: field.soil_class.name
      expect(page).to have_link 'Back to Farms', href: farms_path
      expect(page).to have_link 'Edit', href: edit_farm_path(farm)      
    end
  end

  describe "new page" do
    let(:submit) { "Save" }
    let(:new_farm) { "New Farm" }
    let(:new_block) { "New Block" }
    let(:new_field) { "New Field" }

    before { visit new_farm_path }

    it "has correct page elements" do
      expect(page).to have_title full_title('Add Farm')
      expect(page).to have_selector 'h1', text: 'Add Farm'
    end

    it "should create a new farm" do
      fill_in "Farm Name", with: new_farm
      select('Fabian Garcia Research Center', from: 'Weather Station')
      expect do
        click_button submit
        Company.current_id = user.company.id
      end.to change(Farm, :count).by(1)
    end

    context 'js tests', :slow do

      it "has js to add form fields", js: true do
        init_well_count = IrrigationWell.count
        init_block_count = Block.count
        init_field_count = Field.count
        fill_in "Farm Name", with: new_farm
        select('Fabian Garcia Research Center', from: 'Weather Station')
        click_on 'Add Irrigation Well'
        fill_in 'Well Name', with: 'Pump 1'
        click_on 'Add Block'
        fill_in 'Block', with: '1'
        click_on 'Add Field'
        fill_in  'Field', with: 'A'
        click_button 'Save'
        Company.current_id = user.company.id
        expect(IrrigationWell.count).to be > init_well_count
        expect(Block.count).to be > init_block_count
        expect(Field.count).to be > init_field_count
      end
    end
  end

  describe "edit page" do
    let!(:farm) { FactoryGirl.create(:farm) }
    let!(:block) { FactoryGirl.create(:block, farm: farm) }
    let!(:field) { FactoryGirl.create(:field, block: block) }
    let!(:well) { FactoryGirl.create(:irrigation_well, farm: farm) }

    before { visit edit_farm_path(farm) }

    it "displays correct farm and page elements" do
      expect(page).to have_title "Edit #{farm.name}"
      expect(page).to have_selector 'h1', text: "Edit #{farm.name}"
      expect(page).to have_link "Cancel", href: farm_path(farm)
      expect(page).to have_link "Add Block"
      expect(page).to have_link "Add Field"
    end

    context "with invalid information" do
      
      let(:new_name) { "" }
      let(:submit) { "Save" }

      before do
        fill_in "Farm Name", with: new_name
        click_button submit
      end

      it "renders edit page with error" do
        expect(page).to have_title full_title(new_name)
        expect(page).to have_css '.alert-danger'
      end
    end

    context "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_block) { "NewBlock" }
      let(:new_field) { "NewField" }
      let(:new_well) { "New Well" }
      let(:new_pod_code) { "New Pod Code" }
      let(:submit) { "Save" }
      before do
        fill_in "Farm Name", with: new_name
        fill_in "Well Name", with: new_well
        fill_in "POD Code", with: new_pod_code
        fill_in "Block", with: new_block
        fill_in "Field", with: new_field
        # How can I make capybara find the soil_class select
        # select('6-8cm', from: 'soil_class_id')
        click_button submit
      end

      it "displays the updated attributes" do
        expect(page).to have_title full_title(new_name)
        expect(page).to have_css '.alert-success', text: "Updated"
        expect(farm.reload.name).to eq new_name
        expect(block.reload.name).to eq new_block
        expect(field.reload.name).to eq new_field
        expect(well.reload.name).to eq new_well
        expect(well.reload.pod_code).to eq new_pod_code
      end
    end
  end
end