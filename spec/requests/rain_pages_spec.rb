require 'spec_helper'

describe 'Rain Page' do

  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in(user)
  end

  describe 'GET rain path' do
    it 'renders the rain index view' do
      visit rains_path
      expect(current_path).to eq(rains_path)
    end
  end

end