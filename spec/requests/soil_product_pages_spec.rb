require 'rails_helper'

describe 'SoilProduct' do
  let(:user) { create(:user) }
  subject { page }

  before do
    sign_in(user)
  end

  context 'product list' do
    let!(:product) { create(:soil_product, n: 16, p: 8, k: 3, s: 4) }

    before do
      visit soil_products_path
    end

    it "displays the correct elements" do
      expect(page).to have_title full_title('Soil Products')
      expect(page).to have_selector 'h1', text: 'Soil Products'
      expect(page).to have_selector 'td', text: product.name
      expect(page).to have_selector 'td', text: product.n
      expect(page).to have_selector 'td', text: product.p
      expect(page).to have_selector 'td', text: product.k
      expect(page).to have_selector 'td', text: product.s
      expect(page).to have_link 'edit', 
                                href: edit_soil_product_path(product)
    end
  end

  context 'new form' do
    
    context 'with invalid data' do
      before do
        visit soil_products_path
        click_on 'Save'
      end

      it "displays the correct elements" do
        expect(page).to have_title full_title('Soil Products')
        expect(page).to have_css '.alert-danger'
      end
    end

    context 'with valid data' do
      before do
        visit soil_products_path
        fill_in 'Name', with: 'New product'
        fill_in 'soil_product_n', with: '16'
        fill_in 'soil_product_p', with: '8'
        fill_in 'soil_product_k', with: '3'
        fill_in 'soil_product_s', with: '4'
        click_on 'Save'
      end
      
      it "displays the correct elements" do
        expect(page).to have_selector 'td', text: 'New product'
        expect(page).to have_css '.alert-success'
      end
    end
  end

  context 'edit form' do
    let(:product) { create(:soil_product) }

    before do
      visit edit_soil_product_path(product)
    end

    context 'with invalid data' do
      
      it "displays error message" do
        fill_in 'Name', with: ''
        click_on 'Save'
        expect(page).to have_css '.alert-danger'
      end
    end

    context 'with valid data' do
      
      it "updates the product with success" do
        fill_in 'Name', with: 'Great New Name'
        click_on 'Save'
        expect(page).to have_selector 'td', text: 'Great New Name'
        expect(page).to have_css '.alert-success'
      end
    end
  end
end