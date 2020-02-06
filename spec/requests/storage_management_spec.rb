require 'rails_helper'

RSpec.describe 'StorageManagement', type: :request do
  describe 'Storage Management link' do
    context 'when clicked' do
      it 'redirects to stroage management page' do
        sign_in(create(:user))

        click_link 'Storage Management'

        expect(page).to have_title full_title 'Storage Management'
      end
    end
  end

  describe 'location index' do
    it 'has correct title' do
      sign_in(create(:user))
      visit storage_management_index_path

      expect(page).to have_selector 'h1', text: 'Location Overview'
    end
  end
end
