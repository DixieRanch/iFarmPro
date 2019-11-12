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
      field = create(:field, name: 'C', block: block)
      create(:lot, name: '2019-001', full_weight: 800, box: box,
                   freezer_location: location, block: block,
                   field: field)
      visit lots_path

      expect(page).to have_selector 'td', text: '2019-001'
      expect(page).to have_selector 'td', text: '800'
      expect(page).to have_selector 'td', text: '002'
      expect(page).to have_selector 'td', text: 'A1'
      expect(page).to have_selector 'td', text: 'B'
      expect(page).to have_selector 'td', text: 'C'
    end
  end

  describe 'form' do
    it 'has name text field' do
      sign_in create(:user)
      visit lots_path

      fill_in('Lot Name', with: '2019-001')
    end

    it 'has weight field' do
      sign_in create(:user)
      visit lots_path

      fill_in('Full Weight', with: 1000)
    end

    it 'has box dropdown' do
      sign_in create(:user)
      create(:box, name: '005')
      visit lots_path

      select('005', from: 'Box')
    end

    it 'has freezer location dropdown' do
      sign_in create(:user)
      create(:freezer_location, name: 'A5')
      visit lots_path

      select('A5', from: 'Freezer location')
    end

    it 'has block dropdown' do
      sign_in create(:user)
      create(:block, name: '9')
      visit lots_path

      select('9', from: 'Block')
    end

    it 'has field dropdown' do
      sign_in create(:user)
      create(:field, name: '2')
      visit lots_path

      select('2', from: 'Field')
    end

    it 'has submit button' do
      sign_in create(:user)
      visit lots_path

      click_button 'Save'
    end

    context 'when submitting valid lot data' do
      it 'adds lot to the database' do
        sign_in(user = create(:user))
        create(:box, name: '005')
        create(:freezer_location, name: 'A5')
        create(:block, name: '9')
        create(:field, name: '2')
        visit lots_path

        fill_in('Lot Name', with: '2019-001')
        fill_in('Full Weight', with: 1000)
        select('005', from: 'Box')
        select('A5', from: 'Freezer location')
        select('9', from: 'Block')
        select('2', from: 'Field')

        expect do
          click_button('Save')
          Company.current_id = user.company_id
        end.to(change { Lot.count }.by(1))
      end

      it 'flashes success message' do
        sign_in(create(:user))
        create(:box, name: '005')
        create(:freezer_location, name: 'A5')
        create(:block, name: '9')
        create(:field, name: '2')
        visit lots_path

        fill_in('Lot Name', with: '2019-001')
        fill_in('Full Weight', with: 1000)
        select('005', from: 'Box')
        select('A5', from: 'Freezer location')
        select('9', from: 'Block')
        select('2', from: 'Field')
        click_button 'Save'

        expect(page).to have_css '.alert-success'
      end
    end

    context 'when submitting a blank location name' do
      it 'renders lots index page with correct title' do
        sign_in(create(:user))
        visit lots_path

        click_button('Save')

        expect(page).to have_title full_title 'Lots'
      end
      
      it 'indicates field with error' do
        sign_in(create(:user))
        visit lots_path
        
        click_button 'Save'
        
        expect(page).to have_css('div.has-error')
      end
    end
  end
end
