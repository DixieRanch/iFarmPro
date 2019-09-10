require 'rails_helper'

RSpec.describe 'EmailChanges', type: :request do
  describe 'link' do
    context 'with logged in user' do
      it 'is present' do
        sign_in(create(:user))

        expect(page).to have_link 'Change Email'
      end
    end

    context 'when clicked' do
      it 'redirects to change email page' do
        sign_in(create(:user))

        click_link 'Change Email'

        expect(page).to have_title full_title 'Change Email'
      end
    end
  end
end
