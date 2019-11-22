require 'rails_helper'

describe 'Application' do
  describe 'sidebar' do
    context 'when not signed in' do
      it 'is not displayed' do
        visit root_path

        expect(page).not_to have_css '.sidebar-nav'
      end
    end

    context 'when signed in' do
      it 'should have the correct sidebar elements and links' do
        sign_in(create(:user))
        farm_name = Farm.first.name
        visit root_path

        expect(page).to have_css('#sidebar', text: farm_name)

        click_link 'Farms'

        expect(page).to have_selector 'title', text: full_title('Farms')

        click_link 'Containers'

        expect(page).to have_selector 'title', text: full_title('Containers')

        click_link 'Storage Locations'

        expect(page).to have_selector 'title',
                                      text: full_title('Storage Locations')

        click_link 'Lots'

        expect(page).to have_selector 'title', text: full_title('Lots')

        click_link 'Irrigations'

        expect(page).to have_selector 'title', text: full_title('Irrigations')

        click_link 'Rain'

        expect(page).to have_selector 'title', text: full_title('Rain')

        click_link 'Soil Products'

        expect(page).to have_title full_title('Soil Products')

        click_link 'Soil Applications'

        expect(page).to have_title full_title 'Soil Applications'

        click_link 'Irrigation Schedule'

        expect(page).to have_selector 'title', text: full_title('Schedule')

        click_link 'Nutrition'

        expect(page).to have_title full_title 'Nutrition'

        click_link 'Spray Schedule'

        expect(page).to have_title full_title 'Spray Schedule'
      end
    end
  end

  describe 'layout links' do
    context 'when signed out' do
      it 'should have the correct links' do
        visit root_path

        click_link 'Help'

        expect(page).to have_selector 'title', text: full_title('Help')

        click_link 'Sign in'

        expect(page).to have_selector 'title', text: full_title('Sign in')

        click_link 'iFarmPro'

        expect(page).to have_selector 'title', text: full_title('')

        click_link 'Sign up now!'

        expect(page).to have_selector 'title', text: full_title('Sign up')

        expect(page).to_not have_link(nil, href: '/user_invitations/new')
      end
    end

    context 'when signed in' do
      it 'should have the correct links' do
        sign_in(create(:user))

        click_link 'Help'

        expect(page).to have_selector 'title', text: full_title('Help')
        expect(page).not_to have_link 'Company'

        click_link 'iFarmPro'

        expect(page).to have_title full_title 'Schedule'

        find("a[href='/user_invitations/new']").click
        expect(page).to have_title full_title 'Invite User'

        find("a[href='/email_changes/new']").click
        expect(page).to have_title full_title 'Request Email Change'

        click_link 'Sign out'

        expect(page).to have_selector 'title', text: full_title('')
      end
    end
  end

  describe 'New User signup' do
    it 'goes from initial setup to irrigation schedule', js: true do
      visit root_path
      sign_up_new_user

      expect(page).to have_title 'Add Farm'

      click_link 'iFarmPro'

      expect(page).to have_title full_title 'Add Farm'

      sign_out_then_sign_in

      expect(page).to have_title full_title 'Add Farm'

      fill_in 'Farm Name', with: 'First Farm'
      click_button 'Save'
      click_link 'iFarmPro'

      expect(page).to have_title full_title 'Edit First Farm'

      build_first_farm
      sign_out_then_sign_in

      expect(page).to have_title full_title 'Schedule'
    end

    it 'redirects to farm setup until complete' do
      visit root_path
      sign_up_new_user

      click_link 'Irrigations'

      expect(page).to have_title full_title 'Add Farm'
      expect(page).to have_css '.alert-info'

      fill_in 'Farm Name', with: 'First Farm'
      click_button 'Save'

      expect(page).to have_title full_title 'Edit First Farm'

      click_link 'Irrigations'

      expect(page).to have_title full_title 'Edit First Farm'
    end
  end
end

private

def sign_up_new_user
  create(:weather_station)
  create(:soil_class)
  click_link 'Sign up now!'
  complete_signup_form
  activate_account_with_activation_email
end

def complete_signup_form
  fill_in 'Company Name', with: 'New Company'
  fill_in 'Email', with: 'user@example.com'
  fill_in 'Password', with: 'password'
  fill_in 'Confirmation', with: 'password'
  click_button 'Create my account'
end

def activate_account_with_activation_email
  open_email('user@example.com')
  # Can't click_link a url with js:true, extract email link and visit
  # current_email.click_link 'Activate' <-- won't work with js: true
  url = current_email.find_link('Activate')[:href]
  visit "#{URI(url).path}?email=user%40example.com"
end

def sign_out_then_sign_in
  click_link 'Account'
  click_link 'Sign out'
  click_link 'Sign in'
  fill_in 'Email', with: 'user@example.com'
  fill_in 'Password', with: 'password'
  click_button 'Sign in'
end

def build_first_farm
  click_link 'Add Block'
  click_link 'Add Field'
  fill_in 'Block', with: 1
  fill_in 'Field', with: 1
  click_button 'Save'
end
