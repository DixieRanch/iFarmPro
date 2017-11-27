require 'rails_helper'

describe 'SoilProduct' do
  describe 'list' do
    it 'has the correct page elements' do
      sign_in create(:user)

      visit soil_products_path

      expect(page).to have_title full_title('Soil Products')
      expect(page).to have_selector 'h1', text: 'Soil Products'
    end

    it 'displays soil products' do
      sign_in create(:user)
      product = create(:soil_product, name: 'Some Fertilizer',
                                      n: 16, p: 8, k: 3, s: 4)

      visit soil_products_path

      expect(page).to have_selector 'td', text: 'Some Fertilizer'
      expect(page).to have_selector 'td', text: '16'
      expect(page).to have_selector 'td', text: '8'
      expect(page).to have_selector 'td', text: '3'
      expect(page).to have_selector 'td', text: '4'
      expect(page).to have_link 'edit',
                                href: edit_soil_product_path(product)
    end
  end

  describe 'form' do
    context 'with invalid data' do
      it 'displays error message' do
        sign_in create(:user)
        visit soil_products_path

        click_on 'Save'

        expect(page).to have_title full_title('Soil Products')
        expect(page).to have_css '.alert-danger'
      end
    end

    context 'with valid data' do
      it 'saves the product with success message' do
        sign_in create(:user)
        visit soil_products_path

        fill_in 'Name', with: 'New product'
        fill_in 'soil_product_n', with: '16'
        fill_in 'soil_product_p', with: '8'
        fill_in 'soil_product_k', with: '3'
        fill_in 'soil_product_s', with: '4'
        click_on 'Save'

        expect(page).to have_selector 'td', text: 'New product'
        expect(page).to have_css '.alert-success'
      end
    end
  end

  describe 'edit form' do
    context 'with invalid data' do
      it 'displays error message' do
        sign_in create(:user)
        visit edit_soil_product_path(create(:soil_product))

        fill_in 'Name', with: ''
        click_on 'Save'

        expect(page).to have_css '.alert-danger'
      end
    end

    context 'with valid data' do
      it 'updates the product with success message' do
        sign_in create(:user)
        visit edit_soil_product_path(create(:soil_product))

        fill_in 'Name', with: 'Updated Name'
        click_on 'Save'

        expect(page).to have_selector 'td', text: 'Updated Name'
        expect(page).to have_css '.alert-success'
      end
    end
  end
end
