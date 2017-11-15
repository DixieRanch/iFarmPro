# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  email             :string
#  created_at        :datetime
#  updated_at        :datetime
#  password_digest   :string
#  remember_token    :string
#  company_id        :integer
#  activation_digest :string
#  activated         :boolean          default(FALSE)
#  activated_at      :datetime
#

require 'rails_helper'

describe User do
  valid_attributes = { email: 'user@example.com',
                       password: 'foobar',
                       password_confirmation: 'foobar' }

  it { expect(User.new(valid_attributes)).to be_valid }

  it 'should have a valid factory' do
    factory = FactoryGirl.build(:user)
    expect(factory).to be_valid
  end

  describe 'attributes' do
    it { should have_db_column(:email) }
    it { should have_db_column(:password_digest) }
    it { should have_db_column(:remember_token) }
    it { should have_db_column(:company_id) }
    it { should have_db_column(:activated) }
    it { should have_db_column(:activated_at) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
  end

  describe 'associations' do
    it { should respond_to :company }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it {
      expect(User.new(valid_attributes)).to validate_uniqueness_of(:email)
        .case_insensitive
    }
    it { should validate_length_of(:password).is_at_least(6) }
    it { should validate_confirmation_of(:password) }

    it 'should validate format of e-mail' do
      valid_email = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      invalid_email = %w[user@foo,com user_at_foo.org example.user@foo.
                         foo@bar_baz.com foo@bar+baz.com]

      valid_email.each do |email|
        expect(User.new).to allow_value(email).for(:email)
      end

      invalid_email.each do |email|
        expect(User.new).not_to allow_value(email).for(:email)
      end
    end

    it 'validates password can be nil for exisiting user' do
      create(:user)
      user = User.first

      expect(user.password).to be_nil
      expect(user).to be_valid
    end
  end

  describe 'callbacks' do
    context 'before create' do
      it 'sends account activation email' do
        expect do
          create(:user)
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end
  end

  # Methods

  describe '::new_token' do
    it 'returns a random token' do
      token = User.new_token
      another_token = User.new_token

      expect(token.class).to eq String
      expect(token.length).to eq 22
      expect(another_token).not_to eq token
    end
  end

  describe '::digest' do
    it 'returns hash digest of a given string' do
      digest = User.digest('random string')
      another_digest = User.digest('random string')

      expect(digest.length).to eq 60
      expect(digest.to_s[0..3]).to eq '$2a$'
      expect(another_digest).not_to eq digest
    end
  end

  describe '.authenticated?' do
    it 'returns true if given token matches digest' do
      user = create(:user)
      token = user.activation_token

      expect(user.authenticated?('activation', token)).to be true
    end

    it 'returns false if given the wrong token' do
      user = create(:user)

      expect(user.authenticated?('activation', 'wrong token')).to be false
    end

    it 'returns false if digest is nil' do
      user = create(:user)
      token = user.activation_token
      user.activation_digest = nil

      expect(user.authenticated?('activation', token)).to be false
    end
  end

  describe '.activate' do
    it 'activates a user account' do
      user = create(:user, activated: false)
      expect(user.activated?).to be false

      user.activate
      user.reload

      expect(user.activated).to be true
    end

    it 'sets activate_at to current time' do
      user = create(:user, activated: false)
      expect(user.activated?).to be false

      user.activate
      user.reload

      expect(user.activated_at).to be_within(1.second).of Time.current
    end

    it 'does not reactivate an activated user' do
      user = create(:user, activated: true)

      expect(user.activate).to eq(nil)
      expect(user.activated?).to eq(true)
    end
  end

  describe '.send_activation_email' do
    it 'sends account activation email when user is created' do
      user = User.new(valid_attributes)

      expect do
        user.send_activation_email
      end.to change { ActionMailer::Base.deliveries.count }.by(1)

      digest = BCrypt::Password.new(user.activation_digest)
      expect(digest.is_password?(user.activation_token)).to be true
    end

    it 'updates activation_digest when resending activation email' do
      user = create(:user)
      old_digest = user.activation_digest

      user.send_activation_email
      user.reload
      new_digest = user.activation_digest

      expect(new_digest).not_to eq old_digest
    end

    it "doesn't save the user if it hasn't been created yet" do
      user = User.new(valid_attributes)

      user.send_activation_email

      expect(user.new_record?).to be true
    end
  end

  describe 'create_remember_token' do
    it 'creates remember remember' do
      user = create(:user)

      expect(user.remember_token).not_to be_blank
    end
  end

  describe '#send_password_reset_email' do
    it 'sends password_reset message to UserMailer' do
      user = User.new(valid_attributes)
      email = double('UserMailer.password_reset')

      expect(UserMailer).to receive(:password_reset).with(user) { email }
      expect(email).to receive(:deliver_now)

      user.send_password_reset_email
    end

    it 'persists password reset data' do
      user = User.new(valid_attributes)

      expect do
        user.send_password_reset_email
        user.reload
      end.to((change { user.password_reset_token })
         .and(change { user.password_reset_digest })
         .and(change { user.password_reset_sent_at }))
    end

    it 'creates a token that encrypts to digest' do
      user = User.new(valid_attributes)

      user.send_password_reset_email

      digest = BCrypt::Password.new(user.password_reset_digest)
      expect(digest.is_password?(user.password_reset_token)).to be true
    end

    context 'when requesting new password reset' do
      it 'updates password_reset data' do
        user = User.new(valid_attributes)
        user.send_password_reset_email

        expect do
          user.send_password_reset_email
        end.to(change { user.password_reset_digest })
      end
    end
  end

  describe '#password_reset_expired?' do
    it 'is true with expired password_reset_token' do
      user = User.new(password_reset_sent_at: 121.minutes.ago)

      expect(user.password_reset_expired?).to be true
    end

    it 'is false with unexpired password_reset_token' do
      user = User.new(password_reset_sent_at: 119.minutes.ago)

      expect(user.password_reset_expired?).to be false
    end
  end

  describe '#find_by_email' do
    it 'returns the user when user exists' do
      user = create(:user)
      email = user.email.upcase

      found_user = User.with_email(email)

      expect(found_user).to eq user
    end

    it 'returns the NullUser when user does not exisit' do
      found_user = User.with_email('NoUser@example.com')

      expect(found_user).to be_a(NullUser)
    end
  end
end
