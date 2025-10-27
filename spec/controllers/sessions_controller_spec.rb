require 'rails_helper'

describe SessionsController do
  describe 'POST create' do
    it 'sets attributes for current session' do
      user = create :user
      Company.current_id = user.company.id
      farm = create :farm

      post :create, params: { session: { email: user.email, password: user.password } }
      Company.current_id = user.company.id

      expect(session[:remember_token]).to eq user.remember_token
      expect(session[:farm_id]).to eq farm.id
      expect(subject.send(:current_user)).to eq user
      expect(subject.send(:current_farm)).to eq farm
    end
  end
end
