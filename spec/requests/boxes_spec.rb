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
end
