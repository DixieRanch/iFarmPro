require 'rails_helper'

describe NullUser, :not_a_tenant_model do
  describe '#password_reset_sent_at' do
    it 'returns datetime midnight 1/1/1900' do
      user = NullUser.new

      time = user.email_digest_created_at

      expect(time).to be < 2.hours.ago
    end
  end
end
