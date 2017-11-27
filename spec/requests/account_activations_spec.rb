require 'rails_helper'

describe 'AccountActivations' do
  context 'after clicking link in email' do
    it 'activates user' do
      user = create :user, activated: false
      open_email(user.email)

      expect do
        current_email.click_link 'Activate'
        user.reload
      end.to change { user.activated }.to(true)
    end
  end

  describe '.edit' do
    context 'with correct token and email' do
      it 'activates user' do
        user = create :user, activated: false

        expect do
          visit edit_account_activation_path(user.activation_token,
                                             email: user.email)
          user.reload
        end.to change { user.activated }.to(true)
      end

      it 'signs in user' do
        user = create :user, activated: false

        visit edit_account_activation_path(user.activation_token,
                                           email: user.email)

        expect(page).to have_link('Sign out')
        expect(page).not_to have_selector('h1', text: 'Sign in')
        expect(page).to have_css('div.alert.alert-success', text: 'Activated')
      end
    end

    context 'when user already has farm setup' do
      it 'redirects to irrigation schedule' do
        user = create :user, activated: false
        Company.current_id = user.company.id
        create(:field)
        Company.current_id = nil

        visit edit_account_activation_path(user.activation_token,
                                           email: user.email)

        expect(page).to have_title full_title 'Schedule'
      end
    end

    context 'with incorrect email' do
      it "doesn't activate user" do
        user = create :user, activated: false

        expect do
          visit edit_account_activation_path(user.activation_token,
                                             email: 'wrong@example.com')
          user.reload
        end.not_to change { user.activated }.from(false)
      end

      it 'renders account activation request page' do
        visit edit_account_activation_path(create(:user).activation_token,
                                           email: 'wrong@example.com')

        expect(page).to have_css('div.alert.alert-danger', text: 'Invalid')
        expect(page).to have_title full_title 'Request Account Activation'
      end
    end

    context 'with incorrect token' do
      it "doesn't activate user" do
        user = create :user, activated: false

        expect do
          visit edit_account_activation_path('wrongtoken', email: user.email)
          user.reload
        end.not_to change { user.activated }.from(false)
      end
    end
  end

  describe '.new' do
    it 'renders request account activation page' do
      visit new_account_activation_path
      expect(page).to have_title full_title 'Request Account Activation'
      expect(page).to have_selector 'p', text: 'noreply@ifarmpro.com'
      expect(page).to have_selector 'form'
      expect(page).to have_field 'Email'
    end
  end

  describe '.create' do
    context 'when requesting new activation email' do
      context 'with valid user email' do
        it 'sends correct email' do
          user = create :user, activated: false
          visit new_account_activation_path
          fill_in 'Email', with: user.email

          expect do
            click_button 'Request Email'
          end.to change { ActionMailer::Base.deliveries.count }.by(1)
          open_email(user.email)
          expect(current_email.to).to include user.email
          expect do
            current_email.click_link 'Activate'
            user.reload
          end.to change { user.activated }.to(true)
        end

        it 'redirects to confirmation email page with flash success message' do
          visit new_account_activation_path
          fill_in 'Email', with: 'Any@email.com'

          click_button 'Request Email'

          expect(page).to have_title full_title 'Activation Email Sent'
          expect(page).to have_selector 'h1', text: 'confirmation'
          expect(page).to have_selector 'strong', text: 'Any@email.com'
          expect(page).to have_css(
            'div.alert.alert-success', text: 'Activation'
          )
        end
      end

      context 'with invalid user email' do
        it "doesn't send email, but looks like it did" do
          visit new_account_activation_path
          fill_in 'Email', with: 'not_a_user@hackers.com'

          expect do
            click_button 'Request Email'
          end.not_to(change { ActionMailer::Base.deliveries.count })
          expect(page).to have_selector 'h1', text: 'confirmation'
          expect(page).to have_css('div.alert.alert-success',
                                   text: 'Activation')
        end
      end
    end
  end
end
