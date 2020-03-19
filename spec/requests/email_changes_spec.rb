require 'rails_helper'

RSpec.describe 'EmailChanges', type: :request do
  describe 'new email form' do
    context 'when submiting new email' do
      it 'persists new_email to user'  do
        user = create(:user)
        sign_in(user)

        click_link 'Change Email'
        fill_in('New Email', with: 'new@email.com')
        click_button('Submit Email')
        user.reload

        expect(user.new_email).to eq 'new@email.com'
      end

      it 'redirects to email sent show page' do
        user = create(:user)
        sign_in(user)

        click_link 'Change Email'
        fill_in('New Email', with: 'new@email.com')
        click_button('Submit Email')

        expect(page).to have_title full_title 'Change Email, Email Sent'
        expect(page).to have_selector 'strong', text: 'new@email.com'
      end

      it 'sends an email' do
        user = create(:user)
        sign_in(user)

        click_link 'Change Email'
        fill_in('New Email', with: 'new@email.com')

        expect do
          click_button('Submit Email')
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'sends verification email to the correct address' do
        user = create(:user)
        sign_in(user)

        click_link 'Change Email'
        fill_in('New Email', with: 'new@email.com')
        click_button('Submit Email')

        expect(last_email.to).to eq ['new@email.com']
      end

      it 'sends email with correct subject' do
        user = create(:user)
        sign_in(user)

        click_link 'Change Email'
        fill_in('New Email', with: 'new@email.com')
        click_button('Submit Email')

        expect(last_email.subject).to include 'new email verification'
      end
    end

    context 'when submitting an invalid email' do
      it 'Renders new email form page with correct title' do
        user = create(:user)
        sign_in(user)

        click_link 'Change Email'
        fill_in('New Email', with: 'notanemail.com')
        click_button('Submit Email')

        expect(page).to have_title full_title 'Request Email Change'
      end

      it 'shows a danger flash message for Invalid Email' do
        user = create(:user)
        sign_in(user)

        click_link 'Change Email'
        fill_in('New Email', with: 'notanemail.com')
        click_button('Submit Email')

        expect(page).to have_css('div.alert.alert-danger',
                                 text: 'Invalid Email Address')
      end

      it 'indicates field with error' do
        user = create(:user)
        sign_in(user)

        click_link 'Change Email'
        fill_in('New Email', with: 'notanemail.com')
        click_button('Submit Email')

        expect(page).to have_css('div.has-error')
      end

      it 'does not send email' do
        user = create(:user)
        sign_in(user)

        click_link 'Change Email'
        fill_in('New Email', with: 'notanemail.com')

        expect do
          click_button('Submit Email')
        end.not_to(change { ActionMailer::Base.deliveries.count })
      end
    end

    context 'with blank email' do
      it 'renders new email form page with correct title' do
        user = create(:user)
        sign_in(user)

        click_link 'Change Email'
        click_button('Submit Email')

        expect(page).to have_title full_title 'Request Email Change'
      end

      it 'shows a danger flash message for Invalid Email' do
        user = create(:user)
        sign_in(user)

        click_link 'Change Email'
        click_button('Submit Email')

        expect(page).to have_css('div.alert.alert-danger',
                                 text: 'Invalid Email Address')
      end

      it 'indicates field with error' do
        user = create(:user)
        sign_in(user)

        click_link 'Change Email'
        click_button('Submit Email')

        expect(page).to have_css('div.has-error')
      end
    end

    context 'with logged out user' do
      it 'is not present' do
        expect(page).not_to have_link 'Change Email'
      end
    end
  end

  describe 'new_email email authentication' do
    context 'with valid email and token' do
      it 'renders the email sent index page' do
        user = create(:user)
        sign_in(user)

        click_link 'Change Email'
        fill_in('New Email', with: 'new@email.com')
        click_button('Submit Email')
        user.reload
        open_email(user.new_email)
        current_email.click_link 'Verify New Email'

        expect(page).to have_title full_title 'Confirm Current Email'
      end

      it 'sends an email' do
        user = create(:user)
        sign_in(user)

        click_link 'Change Email'
        fill_in('New Email', with: 'new@email.com')
        click_button('Submit Email')
        user.reload
        open_email(user.new_email)

        expect do
          current_email.click_link 'Verify New Email'
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'sends verification email to the correct address' do
        user = create(:user)
        sign_in(user)

        click_link 'Change Email'
        fill_in('New Email', with: 'new@email.com')
        click_button('Submit Email')
        user.reload
        open_email(user.new_email)
        current_email.click_link 'Verify New Email'

        expect(last_email.to).to eq [user.email]
      end
    end

    context 'with invalid email and token' do
      it 'renders the home page' do
        visit email_changes_path(token: 'wrong_token',
                                 email: 'hacker@email.com')

        expect(page).to have_css 'h1', text: 'Welcome to iFarmPro'
      end
    end
  end

  describe 'current_email email authentication' do
    context 'with invalid email and token' do
      it 'renders the home page' do
        visit edit_email_change_path(token: 'Wrong_token',
                                     email: 'hacker@email.com',
                                     id: 'hacker@email.com')
        expect(page).to have_css 'h1', text: 'Welcome to iFarmPro'
      end
    end

    context 'with valid email and token' do
      it 'updates current email' do
        user = create(:user)
        sign_in user

        click_link 'Change Email'
        fill_in('New Email', with: 'new@email.com')
        click_button('Submit Email')
        user.reload
        open_email(user.new_email)
        current_email.click_link 'Verify New Email'
        open_email(user.email)
        current_email.click_link 'Verify Current Email'
        user.reload

        expect(user.email).to eq 'new@email.com'
      end

      it 'sets new_email to nil' do
        user = create(:user)
        sign_in user

        click_link 'Change Email'
        fill_in('New Email', with: 'new@email.com')
        click_button('Submit Email')
        user.reload
        open_email(user.new_email)
        current_email.click_link 'Verify New Email'
        open_email(user.email)
        current_email.click_link 'Verify Current Email'
        user.reload

        expect(user.new_email).to eq nil
      end

      it 'renders schedule page' do
        user = create(:user)
        sign_in user

        click_link 'Change Email'
        fill_in('New Email', with: 'new@email.com')
        click_button('Submit Email')
        user.reload
        open_email(user.new_email)
        current_email.click_link 'Verify New Email'
        open_email(user.email)
        current_email.click_link 'Verify Current Email'
        user.reload

        expect(page).to have_title full_title 'Schedule'
      end

      it 'flashes a success message' do
        user = create(:user)
        sign_in user

        click_link 'Change Email'
        fill_in('New Email', with: 'new@email.com')
        click_button('Submit Email')
        user.reload
        open_email(user.new_email)
        current_email.click_link 'Verify New Email'
        open_email(user.email)
        current_email.click_link 'Verify Current Email'
        user.reload

        expect(page).to have_css('div.alert.alert-success',
                                 text: 'Your email has been updated.')
      end
    end
  end
end
