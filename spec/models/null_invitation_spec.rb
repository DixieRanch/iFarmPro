require 'rails_helper'

describe NullInvitation, :not_a_tenant_model do
  describe '#invitation_sent_at' do
    it 'returns datetime midnight 1/1/1900' do
      invitation = NullInvitation.new
<<<<<<< afab25c3741940bb46cf56f90fbf4c8daa6ba869

      time = invitation.invitation_sent_at

      expect(time).to be < 7.days.ago
    end
  end
end
=======
      
      time = invitation.invitation_sent_at
      
      expect(time).to be < 7.days.ago
    end
  end
end
>>>>>>> Add null invitations to improve security for user invitation process.
