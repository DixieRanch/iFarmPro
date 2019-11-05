require 'rails_helper'

RSpec.describe 'Lots', type: :request do
  describe 'Lots link' do
    context 'with signed in user' do
      it 'is present' do
        sign_in create(:user)

        click_link 'Lots'
      end
    end
  end
end
