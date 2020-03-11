require 'rails_helper'

RSpec.describe 'Lots', type: :request do
  describe 'link' do
    context 'with signed in user' do
      it 'is present' do
        sign_in create(:user)

        click_link 'Lots'
      end

      context 'when clicked' do
        it 'redirects to lots new' do
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
    it 'has correct title' do
      sign_in create(:user)
      visit new_lot_path

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
      visit new_lot_path

      expect(page).to have_selector 'td', text: '2019-001'
      expect(page).to have_selector 'td', text: '800'
      expect(page).to have_selector 'td', text: '002'
      expect(page).to have_selector 'td', text: 'A1'
      expect(page).to have_selector 'td', text: 'B'
      expect(page).to have_selector 'td', text: 'C'
    end

    it 'has edit link' do
      sign_in create(:user)
      create :lot
      visit new_lot_path

      expect(page).to have_link 'edit'
    end

    context 'with 31 lots' do
      it 'has pagination links' do
        sign_in create(:user)

        31.times do |l|
          create(:lot, name: 'lot' + l.to_s)
        end
        visit new_lot_path

        expect(page).to have_css "//*[@class='pagination']//a[text()='2']"
      end

      it 'has 30 lots on the first page' do
        sign_in create(:user)
        31.times do |l|
          create(:lot, name: 'lot' + l.to_s)
        end
        visit new_lot_path

        expect(page).to have_selector('td', text: 'lot', count: 30)
      end

      it 'has one lot on the second page' do
        sign_in create(:user)
        31.times do |l|
          create(:lot, name: 'lot' + l.to_s)
        end
        visit new_lot_path
        click_link 'Next →'

        expect(page).to have_selector('td', text: 'lot', count: 1)
      end
    end
  end

  describe 'edit link' do
    context 'when clicked' do
      it 'renders the lots page' do
        sign_in create(:user)
        create(:lot, name: '2019-001')
        visit new_lot_path

        click_link 'edit'

        expect(page).to have_title full_title 'Lots'
      end
    end
  end

  describe 'edit form' do
    it 'displays correct box name' do
      sign_in create(:user)
      lot = create(:lot)
      visit new_lot_path

      click_link 'edit'

      expect(page).to have_field('Box Name', with: lot.box.name)
    end

    it 'displays correct field name' do
      sign_in create(:user)
      field = Field.first
      lot = create(:lot, field: field)
      visit new_lot_path

      click_link 'edit'

      expect(page).to have_field('Field', with: lot.field.name)
    end

    context 'with valid input' do
      it 'updates lot data' do
        sign_in create(:user)
        create(:lot, name: '2019-001')
        visit new_lot_path
        click_link 'edit'

        fill_in('Lot Name', with: '2019-002')
        click_button 'Save'

        expect(page).to have_selector 'td', text: '2019-002'
        expect(page).not_to have_selector 'td', text: '2019-001'
      end

      context 'with field' do
        it 'updates the field to nil' do
          sign_in(user = create(:user))
          field = Field.first
          lot = create(:lot, field: field)
          visit new_lot_path

          click_link 'edit'
          fill_in('Field', with: '')

          expect do
            click_button('Save')
            Company.current_id = user.company_id
            lot.reload
          end.to(change { lot.field })
        end

        it 'updates field to new input' do
          sign_in(user = create(:user))
          block = create(:block)
          field = create(:field, block: block)
          lot = create(:lot)
          visit new_lot_path

          click_link 'edit'
          select(block.name, from: 'Block')
          fill_in('Field', with: field.name)

          expect do
            click_button('Save')
            Company.current_id = user.company_id
            lot.reload
          end.to(change { lot.field }.to(field))
        end
      end

      it 'flashes succcess message' do
        sign_in create(:user)
        create(:lot, name: '2019-001')
        visit new_lot_path
        click_link 'edit'

        fill_in('Lot Name', with: '2019-002')
        click_button 'Save'

        expect(page).to have_css '.alert-success'
      end
    end

    context 'with invalid input' do
      it 'indicates field with error' do
        sign_in create(:user)
        create(:lot, name: '2019-001')
        visit new_lot_path

        click_link 'edit'
        fill_in('Lot Name', with: '')
        click_button 'Save'

        expect(page).to have_css('div.has-error')
      end
    end

    context 'with invalid box name' do
      it 'flashes error' do
        sign_in(create(:user))
        create(:lot)
        visit new_lot_path

        click_link 'edit'
        fill_in('Box Name', with: 'No Box')
        click_button 'Save'

        expect(page).to have_css('div.has-error')
      end
    end
  end

  describe 'form' do
    it 'has name text field' do
      sign_in create(:user)
      visit new_lot_path

      fill_in('Lot Name', with: '2019-001')
    end

    it 'has weight field' do
      sign_in create(:user)
      visit new_lot_path

      fill_in('Full Weight', with: 1000)
    end

    it 'has box field' do
      sign_in create(:user)
      visit new_lot_path

      fill_in('Box Name', with: '210')
    end

    it 'has freezer location dropdown' do
      sign_in create(:user)
      create(:freezer_location, name: 'A5')
      visit new_lot_path

      select('A5', from: 'Freezer location')
    end

    it 'has block dropdown' do
      sign_in create(:user)
      create(:block, name: '9')
      visit new_lot_path

      select('9', from: 'Block')
    end

    it 'has field input' do
      sign_in create(:user)
      visit new_lot_path

      fill_in('Field', with: '1')
    end

    it 'has submit button' do
      sign_in create(:user)
      visit new_lot_path

      click_button 'Save'
    end

    it 'has contents dropdown' do
      sign_in create(:user)
      create(:content, name: '#1s')
      visit new_lot_path

      select('#1s', from: 'Contents')
    end

    context 'when submitting valid lot data' do
      it 'adds lot to the database' do
        sign_in(user = create(:user))
        create(:box, name: '005')
        create(:freezer_location)
        visit new_lot_path

        fill_in('Lot Name', with: '2019-001')
        fill_in('Full Weight', with: 1000)
        fill_in('Box Name', with: '005')

        expect do
          click_button('Save')
          Company.current_id = user.company_id
        end.to(change { Lot.count }.by(1))
      end

      it 'flashes success message' do
        sign_in(create(:user))
        create(:box, name: '005')
        create(:freezer_location)
        visit new_lot_path

        fill_in('Lot Name', with: '2019-001')
        fill_in('Full Weight', with: 1000)
        fill_in('Box Name', with: '005')
        click_button 'Save'

        expect(page).to have_css '.alert-success'
      end
    end

    context 'with field' do
      it 'saves lot with correct field' do
        sign_in user = create(:user)
        box = create(:box)
        create(:freezer_location)
        block_a = create(:block, name: 'A')
        create(:field, name: '1', block: block_a)
        block_b = create(:block, name: 'B')
        field_b = create(:field, name: '1', block: block_b)
        visit new_lot_path

        fill_in('Lot Name', with: '2019-001')
        fill_in('Full Weight', with: 1000)
        fill_in('Box Name', with: box.name)
        select(block_b.name, from: 'Block')
        fill_in('Field', with: field_b.name)
        click_button 'Save'

        Company.current_id = user.company_id
        expect(Lot.first.field).to eq field_b
      end
    end

    context 'when submitting a blank form' do
      it 'renders lots index page with correct title' do
        sign_in(create(:user))
        visit new_lot_path

        click_button('Save')

        expect(page).to have_title full_title 'Lots'
      end

      it 'indicates field with error' do
        sign_in(create(:user))
        visit new_lot_path

        click_button 'Save'

        expect(page).to have_css('div.has-error')
      end
    end

    context 'when submitting invalid box name' do
      it 'flashes error' do
        sign_in(create(:user))
        create(:box, name: '005')
        create(:freezer_location)
        visit new_lot_path

        fill_in('Lot Name', with: '2019-001')
        fill_in('Full Weight', with: 1000)
        fill_in('Box Name', with: '003')
        click_button 'Save'

        expect(page).to have_css('div.has-error')
      end
    end
  end
end
