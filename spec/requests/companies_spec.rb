require 'rails_helper'

describe 'Companies' do
  describe 'signup page' do
    it 'has correct elements' do
      visit signup_path

      expect(page).to have_title full_title('Sign up')
      expect(page).to have_selector('h1', text: 'Sign up')
    end

    context 'with invalid information' do
      it 'should not create a company when user is invalid' do
        visit signup_path
        fill_in 'Company Name', with: 'Any Company'

        expect { click_button 'Create' }.not_to change(Company, :count)
      end

      it 'should not create a user when company is invalid' do
        visit signup_path
        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Confirmation', with: 'password'

        expect { click_button 'Create' }.not_to change(User, :count)
      end

      it 'should show error messages' do
        visit signup_path

        click_button 'Create'

        expect(page).to have_css('div.alert-danger')
      end
    end

    context 'with valid information' do
      it 'should create a company and user' do
        visit signup_path
        fill_in_valid_signup_information

        expect { click_button 'Create' }.to(change(Company, :count).by(1)
                                        .and(change(User, :count).by(1)))
      end

      it 'sends activation email' do
        visit signup_path
        fill_in_valid_signup_information

        expect do
          click_button 'Create'
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'redirects to Activation Email Sent page' do
        visit signup_path
        fill_in_valid_signup_information

        click_button 'Create'

        expect(page).to have_title full_title 'Activation Email Sent'
        expect(page).to have_css('div.alert.alert-success', text: 'Welcome')
        expect(page).to have_text 'user@example.com'
      end

      context 'after activating account' do
        it 'displays welcome message on New Farm Page' do
          visit signup_path
          fill_in_valid_signup_information
          click_button 'Create'
          open_email('user@example.com')

          current_email.click_link 'Activate'

          expect(page).to have_title full_title 'Add Farm'
          expect(page).to have_css('div.alert.alert-success',
                                   text: 'Activated!')
        end
      end
    end
  end

  describe 'show page' do
    it 'has the correct elements' do
      user = create(:user)
      sign_in(user)

      visit company_path(user.company)

      expect(page).to have_title full_title user.company.name
    end
  end
end

def fill_in_valid_signup_information
  fill_in 'Company Name', with: 'Any Company'
  fill_in 'Email',        with: 'user@example.com'
  fill_in 'Password',     with: 'password'
  fill_in 'Confirmation', with: 'password'
end
