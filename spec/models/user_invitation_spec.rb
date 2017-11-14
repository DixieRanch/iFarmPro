require 'rails_helper'

describe UserInvitation do
  describe 'associations' do
    it 'respond to company' do
      invitation = UserInvitation.new

      expect(invitation).to respond_to :company
    end
  end
end
