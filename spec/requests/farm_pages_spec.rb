require 'spec_helper'

describe "Farm" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in(user)
    Company.current_id = user.company.id
  end

  describe "index page" do

    context "without an exisiting farm" do
      before { visit farms_path }

      it { should have_selector 'title', text: full_title('Farm') }
      it { should have_link('New Farm', href: new_farm_path) }
    end

    context "with an exisiting farm" do

      let!(:farm) { FactoryGirl.create(:farm) }

      before { visit farms_path }

      it { should have_selector 'title', text: full_title('Farm') }
      it { should have_link farm.name, href: farm_path(farm) }
      it { should_not have_link('New Farm', href: new_farm_path) }
    end
  end

  describe "show page" do
    let!(:farm) { FactoryGirl.create(:farm) }
    let!(:block) { FactoryGirl.create(:block, farm: farm) }
    let!(:field) { FactoryGirl.create(:field, block: block) }

    before { visit farm_path(farm) }

    it { should have_selector 'title', text: full_title(farm.name) }
    it { should have_selector 'h1', text: farm.name }
    it { should have_selector 'td', text: block.name }
    it { should have_selector 'td', text: field.name }
    it { should have_selector 'td', text: field.soil_class.name }
    it { should have_link 'Back to Farms', href: farms_path }
    it { should have_link 'Edit', href: edit_farm_path(farm) }
  end

  describe "new page" do
    let(:submit) { "Save" }
    let(:new_farm) { "New Farm" }
    let(:new_block) { "New Block" }
    let(:new_field) { "New Field" }

    before { visit new_farm_path }

    it { should have_selector 'title', text: full_title('Add Farm') }
    it { should have_selector 'h1', text: 'Add Farm' }

    it "should create a new farm" do
      fill_in "Farm Name", with: new_farm
      select('Fabian Garcia Research Center', from: 'Weather Station')
      expect do
        click_button submit
        Company.current_id = user.company.id
      end.to change(Farm, :count).by(1)
    end
  end

  describe "edit page" do
    let!(:farm) { FactoryGirl.create(:farm) }
    let!(:block) { FactoryGirl.create(:block, farm: farm) }
    let!(:field) { FactoryGirl.create(:field, block: block) }
    let!(:well) { FactoryGirl.create(:irrigation_well, farm: farm) }

    before { visit edit_farm_path(farm) }

    it { should have_selector 'title', text: "Edit #{farm.name}" }
    it { should have_selector 'h1', text: "Edit #{farm.name}" }
    it { should have_link "Cancel", href: farm_path(farm) }
    it { should have_link "Add Block" }
    it { should have_link "Add Field" }

    context "with invalid information" do
      let(:new_name) { "" }
      let(:submit) { "Save" }
      before do
        fill_in "Farm Name", with: new_name
        click_button submit
      end

      #it { should have_selector 'title', text: "Edit #{new_name}" } # old capybara version 1 style
      it 'should have_selector title' do
        expect(page).to have_title "Edit #{new_name}"
      end

      it { should have_css '.alert-error' }
    end

    context "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_block) { "New Block" }
      let(:new_field) { "New Field" }
      let(:new_well) { "New Well" }
      let(:new_pod_code) { "New Pod Code" }
      let(:submit) { "Save" }
      before do
        fill_in "Farm Name", with: new_name
        # fill_in "Irrigation Well Name", with: new_well
        # fill_in "POD Code", with: new_pod_code
        # fill_in "Block", with: new_block
        # fill_in "Field", with: new_field
        # select('6-8cm', from: 'Soil Type')
        click_button submit
      end

      it { should have_selector 'title', text: full_title(new_name) }
      it { should have_css '.alert-success', text: "Updated" }
      specify { farm.reload.name.should == new_name }
      # specify { block.reload.name.should == new_block }
      # specify { field.reload.name.should == new_field }
      # specify { well.reload.name.should == new_well }
      # specify { well.reload.pod_code.should == new_pod_code }
    end
  end
end