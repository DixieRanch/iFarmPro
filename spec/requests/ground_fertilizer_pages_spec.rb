require 'spec_helper'

describe 'GroundFertilizer' do

  let(:user) { FactoryGirl.create(:user) }
  subject { page }

  before do
    sign_in(user)
    Company.current_id = user.company.id
  end

  context 'fertilizer list' do
    let!(:fertilizer) { create(:ground_fertilizer, n: 16, p: 8, k: 3, s: 4) }

    before do
      visit ground_fertilizers_path
      Company.current_id = user.company.id
    end

    it "displays the correct elements" do
      expect(page).to have_title full_title('Ground Fertilizers')
      expect(page).to have_selector 'h1', text: 'Ground Fertilizers'
      expect(page).to have_selector 'td', text: fertilizer.name
      expect(page).to have_selector 'td', text: fertilizer.n
      expect(page).to have_selector 'td', text: fertilizer.p
      expect(page).to have_selector 'td', text: fertilizer.k
      expect(page).to have_selector 'td', text: fertilizer.s
      expect(page).to have_link 'edit', 
                                  href: edit_ground_fertilizer_path(fertilizer)
    end
  end

  context 'new form' do
    
    context 'with invalid data' do

      before do
        visit ground_fertilizers_path
        # Company.current_id = user.company.id
        click_on 'Save'
      end

      it "displays the correct elements" do
        expect(page).to have_title full_title('Ground Fertilizers')
        expect(page).to have_css '.alert-error'
      end
    end

    context 'with valid data' do

      before do
        visit ground_fertilizers_path
        fill_in 'Name', with: 'New Fertilizer'
        fill_in 'ground_fertilizer_n', with: '16'
        fill_in 'ground_fertilizer_p', with: '8'
        fill_in 'ground_fertilizer_k', with: '3'
        fill_in 'ground_fertilizer_s', with: '4'
        click_on 'Save'
      end
      
      it "displays the correct elements" do
        expect(page).to have_selector 'td', text: 'New Fertilizer'
        expect(page).to have_css '.alert-success'
      end
    end
  end

  context 'edit form' do
    let(:fertilizer) { create(:ground_fertilizer) }

    before do
      visit edit_ground_fertilizer_path(fertilizer)
      Company.current_id = user.company.id
    end

    context 'with invalid data' do
      
      it "displays error message" do
        fill_in 'Name', with: ''
        click_on 'Save'
        expect(page).to have_css '.alert-error'
      end
    end

    context 'with valid data' do
      
      it "updates the fertilizer" do
        fill_in 'Name', with: 'Great New Name'
        click_on 'Save'
        expect(page).to have_selector 'td', text: 'Great New Name'
      end

      it "displays success message" do
        click_on 'Save'
        expect(page).to have_css '.alert-success'
      end
    end
  end
end