require 'spec_helper'

describe 'GroundFertilizer' do

  let(:user) { FactoryGirl.create(:user) }
  subject { page }

  before do
    sign_in(user)
    Company.current_id = user.company.id
  end

  describe 'index page' do
    
    context 'current fertilizer list' do
      let!(:fertilizer) { create(:ground_fertilizer) }

      before do
        visit ground_fertilizers_path
        Company.current_id = user.company.id
      end

      it "displays the correct elements" do
        expect(page).to have_title full_title('Ground Fertilizers')
        expect(page).to have_selector 'h1', text: 'Ground Fertilizers'
        expect(page).to have_selector 'td', text: fertilizer.name
      end
    end

    context 'new fertilizer form' do
      
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
  end
end