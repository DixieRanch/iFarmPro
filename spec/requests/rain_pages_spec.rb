require 'spec_helper'

describe 'Rain Page' do

  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    visit rains_path
    sign_in(user)
  end

  describe 'GET rain path' do
    it 'renders the rain index view' do
      expect(current_path).to eq(rains_path)
    end
  end

  describe 'page detail' do
    it 'displays header 1' do
      expect(page).to have_selector 'h1', text: 'Current Rain'
    end

    it 'populates title' do
      expect(page).to have_title full_title('Rain')
    end
  end

end