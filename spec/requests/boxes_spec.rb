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

    it 'has edit links' do
      sign_in create(:user)
      box = create(:box, name: '001', empty_weight: 200)

      visit boxes_path

      expect(page).to have_link 'edit', href: edit_box_path(box)
    end

    context 'with 31 containers' do
      it 'has pagination links' do
        user = create :user
        sign_in user
        31.times do |n|
          create(:box, name: n, empty_weight: 200)
        end

        visit boxes_path

        find("//*[@class='pagination']//a[text()='2']").click
        expect(page.status_code).to eq(200)
      end
    end
  end

  describe 'form' do
    it 'has name field' do
      sign_in create(:user)
      visit boxes_path

      fill_in 'Name', with: '2019-001'
    end

    it 'has empty weight field' do
      sign_in create(:user)
      visit boxes_path

      fill_in 'Empty Weight', with: '150'
    end

    it 'has save button' do
      sign_in create(:user)
      visit boxes_path

      click_button 'Save Container'
    end

    context 'with invalid data' do
      it 'renders container page with errors' do
        sign_in create(:user)
        visit boxes_path

        click_button 'Save Container'

        expect(page).to have_title full_title('Containers')
        expect(page).to have_css('div.has-error')
      end
    end

    context 'with valid data' do
      it 'adds container to the database' do
        sign_in(user = create(:user))
        visit boxes_path

        fill_in 'Name', with: '2019-001'
        fill_in 'Empty Weight', with: '200'

        expect do
          click_button 'Save Container'
          Company.current_id = user.company_id
        end.to(change { Box.count }.by(1))
      end

      it 'flashes success message' do
        sign_in(create(:user))
        visit boxes_path

        fill_in 'Name', with: '2019-001'
        fill_in 'Empty Weight', with: '200'
        click_button 'Save Container'

        expect(page).to have_css '.alert-success'
      end
    end
  end

  describe 'edit link' do
    context 'when clicked' do
      it 'renders the storage locations page' do
        sign_in create(:user)
        create(:box, name: '001', empty_weight: 200)
        visit boxes_path

        click_link 'edit'

        expect(page).to have_title 'Containers'
      end
    end
  end
end
