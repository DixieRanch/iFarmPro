require 'rails_helper'

RSpec.describe 'Lots', type: :request do
  describe 'Lots link' do
    context 'with signed in user' do
      it 'is present' do
        sign_in create(:user)

        click_link 'Lots'
      end

      context 'when clicked' do
        it 'redirects to lots index' do
          sign_in create(:user)

          click_link 'Lots'

          expect(page).to have_title full_title 'Lots'
        end
      end
    end

    context 'with signed out user' do
      it 'is absent' do
        visit root_path

        expect(page).not_to have_link 'Lots'
      end
    end
  end

  describe 'list' do
    it 'has title' do
      sign_in create(:user)
      visit lots_path

      expect(page).to have_selector 'h1', text: 'Lots'
    end

    it 'has created lots' do
      sign_in(create(:user))
      box = create(:box, name: '002')
      location = create(:freezer_location, name: 'A1')
      block = create(:block, name: 'B')
      create(:lot, name: '2019-001', full_weight: 800, box: box,
                   freezer_location: location, block: block)
      visit lots_path

      expect(page).to have_selector 'td', text: '2019-001'
      expect(page).to have_selector 'td', text: '800'
      expect(page).to have_selector 'td', text: '002'
      expect(page).to have_selector 'td', text: 'A1'
      expect(page).to have_selector 'td', text: 'B'
    end
  end
end
