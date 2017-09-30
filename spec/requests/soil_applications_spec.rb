require 'rails_helper'

describe "SoilApplication" do
  let(:user) { create(:user) }

  before do
    sign_in(user)
  end

  describe "page" do
    
    it "has correct elements" do
      visit soil_applications_path
      expect(page).to have_title full_title 'Soil Applications'
      expect(page).to have_selector 'h1', text: 'Current Applications'
    end
  end
  
  describe "current applications list" do

    it "displays soil app fields" do
      soil_app = create(:soil_application)
      visit soil_applications_path
      expect(page).to have_selector 'td', text: soil_app.formatted_date
      expect(page).to have_selector 'td', text: soil_app.field.name_with_block
      expect(page).to have_selector 'td', text: soil_app.soil_product.name
      expect(page).to have_selector 'td', text: soil_app.quantity
      expect(page).to have_link     'edit', 
                                    href: edit_soil_application_path(soil_app)
    end
    
    context "with 31 applications", slow: true do
      
      let(:app_table) { "table#application_table tbody tr" }
      let(:pagination_link) { "//*[@class='pagination']//a[text()='2']" }
      
      before do
        Company.current_id = user.company.id
        31.times do |i|
          create(:soil_application)
        end
        visit soil_applications_path
      end
      
      it "has pagination links" do
        expect(page).to have_selector app_table, count: 30
        find(pagination_link).click
        expect(page).to have_selector 'em.current', text: 2
      end
    end
  end

  describe "new application form" do
    before do
      create(:field, name: '1', block: create(:block, name: '1'))
      create(:soil_product, name: '32-0-0-0')
      create(:soil_application_unit)
      visit soil_applications_path
    end
    
    context 'with invalid data' do
      
      before do
        click_button 'Save'
      end

      it "renders Soil App page with error" do
        expect(page).to have_title full_title 'Soil Applications'
        expect(page).to have_css '.alert-danger'
      end
    end

    context 'with valid data' do

      before do
        select '1-1', from: 'soil_application_field_id'
        fill_in 'Date', with: '4/1'
        select '32-0-0-0', from: 'soil_application_soil_product_id'
        fill_in 'Quantity', with: 15
        select 'Gal', from: 'soil_application_soil_application_unit_id'
        click_button 'Save'
      end

      it "displays the new record with success" do
        expect(page).to have_selector 'td', text: '1-1'
        year = Time.now.year
        expect(page).to have_selector 'td', text: "April 1, #{year}"
        expect(page).to have_css '.alert-success'
      end
    end
  end

  describe "edit page" do
    
    before do
      create(:soil_application)
      create(:field, name: 'One', block: create(:block, name: 'This'))      
      visit soil_applications_path
      click_link 'edit'
    end

    context 'with invalid data' do
      
      it "has error message" do
        fill_in 'Quantity', with: ''
        click_button 'Save'
        expect(page).to have_css '.alert-danger'
      end
    end

    context 'with valid data' do

      it "updates soil application with success" do
        fill_in 'Date', with: '1/4'
        select('This-One', from: 'soil_application_field_id')
        click_button 'Save'
        year = Time.now.year
        expect(page).to have_selector 'td', text: "January 4, #{year}"
        expect(page).to have_css '.alert-success'
      end
    end
  end
end