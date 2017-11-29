require 'rails_helper'

describe UserInvitation, :not_a_tenant_model do
  describe 'associations' do
    it { should belong_to :company }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }

    it 'should validate email format' do
      valid_email = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      invalid_email = %w[user@foo,com user_at_foo.org example.user@foo.
                         foo@bar_baz.com foo@bar+baz.com]

      valid_email.each do |email|
        expect(UserInvitation.new).to allow_value(email).for(:email)
      end

      invalid_email.each do |email|
        expect(UserInvitation.new).not_to allow_value(email).for(:email)
      end
    end
  end

  describe '#send_invitation_email' do
    it 'sends invitation message to UserMailer' do
      invitation = UserInvitation.new(email: 'newUser@example.com')
      email = double('UserMailer.invitation')

      expect(UserMailer).to receive(:invitation).with(invitation) { email }
      expect(email).to receive(:deliver_now)

      invitation.send_invitation_email
    end

    it 'creates a token which encrypts to a digest' do
      invitation = UserInvitation.new(email: 'newUser@example.com')

      invitation.send_invitation_email
      digest = BCrypt::Password.new(invitation.invitation_digest)

      expect(digest.is_password?(invitation.invitation_token)).to be true
    end
  end
end
