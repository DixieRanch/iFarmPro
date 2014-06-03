require 'spec_helper'

describe "SoilApplication" do
  let(:user) { create(:user) }
  subject { page }

  before do
    sign_in(user)
    Company.current_id = user.company.id
  end

  describe "index page" do

    before do
      visit soil_applications_path
    end

    it "has correct elements" do
      expect(page).to have_title full_title 'Soil Applications'
      expect(page).to have_selector 'h1', text: 'Current Applications'
    end


    describe "current applications list" do

      before do
        Company.current_id = user.company.id
        @app = create(:soil_application)
        visit soil_applications_path
      end

      let(:field_name) { @app.field.name_with_block }

      it "displays soil app fields" do
        expect(page).to have_selector 'td', text: @app.formatted_date
        expect(page).not_to have_selector 'td', text: @app.date.to_s(:rfc822)
        expect(page).to have_selector 'td', text: @app.field.name_with_block
        expect(page).to have_selector 'td', text: @app.soil_product.name
        expect(page).to have_selector 'td', text: @app.quantity
        expect(page).to have_link 'edit', href: edit_soil_application_path(@app)
      end

      end

    describe "new application form" do
      before do
        Company.current_id = user.company.id
        create(:field, name: '1', block: create(:block, name: '1'))
        create(:soil_product, name: '32-0-0-0')
        visit soil_applications_path
      end
      
      context 'with invalid data' do
        
        before do
          click_button 'Save'
        end

        it "renders Soil App page with error" do
          expect(page).to have_title full_title 'Soil Applications'
          expect(page).to have_css '.alert-error'
        end
      end

      context 'with valid data' do

        before do
          select('1-1', from: 'soil_application_field_id')
          fill_in 'Date', with: '4/1'
          select '32-0-0-0', from: 'soil_application_soil_product_id'
          fill_in 'Quantity', with: 150
          click_button 'Save'
        end

        it "displays the new record with success" do
          expect(page).to have_selector 'td', text: '1-1'
          expect(page).to have_css '.alert-success'
        end
      end
    end
  end

  describe "edit page" do
    before do
      @app = create(:soil_application)
      visit soil_applications_path
      click_link 'edit'
    end

    context 'with invalid data' do
      
      it "has error message" do
        fill_in 'Quantity', with: ''
        click_button 'Save'
        expect(page).to have_css '.alert-error'
      end
    end

    context 'with valid data' do

      it "updates soil application with success" do
        fill_in 'Date', with: '1/4'
        click_button 'Save'
        expect(page).to have_selector 'td', text: '2014-01-04'  
        expect(page).to have_css '.alert-success'
      end
    end
  end
end