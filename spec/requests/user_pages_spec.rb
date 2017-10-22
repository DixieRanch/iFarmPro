require 'rails_helper'

describe 'UserPages' do
  subject { page }

  describe 'new' do
    let(:user) { create(:user) }
    let(:attr) { attributes_for(:user) }
    before do
      sign_in user
      visit new_user_path
    end

    context 'with invalid information' do
      before do
        fill_in 'Email', with: ''
        fill_in 'Password', with: ''
        fill_in 'Confirmation', with: ''
      end

      it 'should not create a user' do
        expect  do
          click_button 'Save'
        end.not_to change(User, :count)
      end

      it 'should display error messages' do
        click_button 'Save'
        expect(page).to have_css '.alert-danger'
      end
    end

    context 'with valid information' do
      before do
        fill_in 'Email', with: attr[:email]
        fill_in 'Password', with: attr[:password]
        fill_in 'Confirmation', with: attr[:password]
      end

      it 'should create a new user' do
        expect do
          click_button 'Save'
        end.to change(User, :count).by(1)
      end

      it 'should create a user for the correct company with success' do
        click_button 'Save'
        new_user = User.find_by(email: attr[:email])
        expect(new_user.company_id).to eq user.company_id
        expect(page).to have_css '.alert-success'
      end
    end
  end

  describe 'change password link' do
    it 'renders password reset email sent page' do
      user = create(:user)
      sign_in user

      click_link 'Change Password'

      expect(page).to have_title full_title 'Password Reset Email Sent'
    end

    it 'sends password reset email to current user' do
      user = create(:user)
      sign_in user

      click_link 'Change Password'

      last_email = ActionMailer::Base.deliveries.last
      expect(last_email.to).to eq [user.email]
      expect(last_email.subject).to include 'password reset'
    end
  end
end
