require 'rails_helper'

RSpec.describe 'Boxes' do
  describe 'link' do
    context 'with signed in user' do
      it 'is present' do
        sign_in(create(:user))

        expect(page).to have_link 'Containers'
      end
    end
  end

  describe 'list' do
    it 'has the correct title' do
      user = create :user
      sign_in user

      visit boxes_path
      Company.current_id = user.company.id

      expect(page).to have_selector 'title', text: full_title('Containers')
    end

    it 'has correct header' do
      user = create :user
      sign_in user

      visit boxes_path
      Company.current_id = user.company.id

      expect(page).to have_selector 'h1', text: 'Current Containers'
    end

    it 'has container name' do
      user = create :user
      sign_in user
      create(:box, name: '001', empty_weight: 200)

      visit boxes_path
      Company.current_id = user.company.id

      expect(page).to have_selector 'td', text: '001'
    end

    it 'has container weight' do
      user = create :user
      sign_in user
      create(:box, name: '001', empty_weight: 200)

      visit boxes_path
      Company.current_id = user.company_id

      expect(page).to have_selector 'td', text: '200'
    end
  end
end
