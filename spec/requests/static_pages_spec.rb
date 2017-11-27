require 'rails_helper'

describe 'StaticPages' do
  describe 'Home' do
    it 'has the correct page elements' do
      visit root_path

      expect(page).to have_selector('h1', text: 'iFarmPro')
      expect(page).to have_title full_title('')
      expect(page).not_to have_selector('title', text: '| Home')
    end
  end

  describe 'Help' do
    it 'has the correct page elements' do
      visit help_path

      expect(page).to have_selector('h1', text: 'Help')
      expect(page).to have_title full_title('Help')
    end
  end

  describe 'About' do
    it 'has the correct page elements' do
      visit about_path

      expect(page).to have_selector('h1', text: 'About iFarmPro')
      expect(page).to have_title full_title('About')
    end
  end

  describe 'Contact' do
    it 'has the correct page elements' do
      visit contact_path

      expect(page).to have_selector('h1', text: 'Contact iFarmPro')
      expect(page).to have_title full_title('Contact')
    end
  end
end
