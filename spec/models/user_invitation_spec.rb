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

    it 'should validate uniqueness within User database' do
      user = create(:user)

      expect(user).to allow_value(user.email).for(:email)
      expect(UserInvitation.new).to allow_value('any@email.willdo').for(:email)
      expect(UserInvitation.new).not_to allow_value(user.email).for(:email)
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

    it 'persists invitation data' do
      invitation = UserInvitation.new(email: 'newUser@example.com')

      expect do
        invitation.send_invitation_email
      end.to((change { invitation.invitation_token })
         .and(change { invitation.invitation_digest })
         .and(change { invitation.invitation_sent_at }))
    end
  end

  describe '#invitation_expired?' do
    it 'is true with expired invitation_token' do
      invitation = UserInvitation.new(invitation_sent_at: 10080.minutes.ago)

      expect(invitation.invitation_expired?).to be true
    end

    it 'is false with unexpired invitation_token' do
      invitation = UserInvitation.new(invitation_sent_at: 10079.minutes.ago)

      expect(invitation.invitation_expired?).to be false
    end
  end
end
