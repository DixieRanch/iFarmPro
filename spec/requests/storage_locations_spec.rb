require 'rails_helper'

RSpec.describe 'StorageLocations', type: :request do
  describe 'Storage Locations link' do
    context 'when clicked' do
      it 'redirects to storage locations form' do
        sign_in(create(:user))
        visit root_path

        click_link 'Storage Locations'

        expect(page).to have_title full_title 'Storage Locations'
      end
    end
  end
  describe 'Storage Locations form' do
    it 'has location_name field' do
      sign_in(create(:user))
      visit root_path
      click_link 'Storage Locations'

      fill_in('Location Name', with: 'newlocation')
    end
  end
end
