require 'rails_helper'

describe 'Authentication' do
  describe 'signin page' do
    it 'has the proper elements' do
      visit signin_path

      expect(page).to have_selector('h1', text: 'Sign in')
      expect(page).to have_title 'Sign in'
      expect(page).to have_link('Sign up now!', href: signup_path)
    end

    context 'with invalid information' do
      it 'redirects to signin' do
        visit signin_path

        click_button 'Sign in'

        expect(page).to have_title 'Sign in'
        expect(page).to have_css('div.alert.alert-danger', text: 'Invalid')
      end
    end

    context 'with valid information' do
      it 'signs in user' do
        create(:user, email: 'user@example.com', password: 'Password')
        visit signin_path

        fill_in 'Email',    with: 'User@Example.com'
        fill_in 'Password', with: 'Password'
        click_button 'Sign in'

        expect(page).to have_title full_title 'Add Farm'
        expect(page).to have_link 'Sign out'
        expect(page).not_to have_link 'Sign in'
      end
    end

    context 'when account not activated' do
      it 'redirects to Activation Email Sent page' do
        user = create(:user, activated: false)
        visit signin_path

        fill_in 'Email',    with: user.email
        fill_in 'Password', with: user.password
        click_button 'Sign in'

        expect(page).to have_title full_title 'Activation Email Sent'
        expect(page).to have_link 'Sign in'
      end
    end

    context 'when activation email not sent' do
      it 'sends email' do
        user = create(:user, activated: false)
        user.update_attributes(activation_digest: nil)
        visit signin_path

        fill_in 'Email',    with: user.email
        fill_in 'Password', with: user.password

        expect do
          click_button 'Sign in'
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context 'when activation email previously sent' do
      it "doesn't send email" do
        user = create(:user, activated: false)
        visit signin_path

        fill_in 'Email',    with: user.email
        fill_in 'Password', with: user.password

        expect do
          click_button 'Sign in'
        end.not_to(change { ActionMailer::Base.deliveries.count })
      end
    end
  end

  describe 'signout link' do
    it 'signs out user' do
      sign_in create(:user)
      visit root_path

      click_link 'Sign out'

      expect(page).to have_link 'Sign in'
      expect(page).not_to have_link 'Sign out'
    end
  end

  describe 'authorization' do
    # let(:user) { create(:user) }

    context 'for non-signed-in users' do
      context 'when attempting to visit a protected page' do
        # before { visit new_farm_path }

        it 'redirects to signin' do
          visit new_farm_path

          expect(page).to have_title 'Sign in'
          expect(page).to have_css('div.alert.alert-notice')
        end

        it 'should render the desired protected page after signing in' do
          visit new_farm_path

          sign_in create(:user)

          expect(page).to have_title full_title 'Add Farm'
        end

        it 'should render the Add Farm page when signing in again' do
          user = create(:user)
          sign_in_new(user)
          click_link 'Sign out'

          sign_in_new(user)

          expect(page).to have_title full_title 'Add Farm'
        end
      end

      context 'when attempting to access protected action' do
        it 'redirects to signin page' do
          post users_path

          expect(response).to redirect_to(signin_path)
        end
      end
    end

    context 'for correct company' do
      it 'resets Company.current_id after every action' do
        sign_in_new create(:user)
        expect(Company.current_id).not_to be_nil

        visit root_path

        expect(Company.current_id).to be_nil
      end
    end
  end
end
