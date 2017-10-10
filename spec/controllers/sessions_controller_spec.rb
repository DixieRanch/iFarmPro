require 'rails_helper'

describe SessionsController do
  describe 'POST create' do
    context 'with valid attributes' do
      before do
        @user = FactoryGirl.create(:user)
        Company.current_id = @user.company.id
        @farm = FactoryGirl.create(:farm)
        @attr = { email: @user.email, password: @user.password }
        post :create, session: @attr
        Company.current_id = @user.company.id
      end

      it 'sets attributes for current session' do
        expect(session[:remember_token]).to eq @user.remember_token
        expect(session[:farm_id]).to eq @farm.id
        expect(subject.send(:current_user)).to eq @user
        expect(subject.send(:current_farm)).to eq @farm
      end
    end
  end
end
