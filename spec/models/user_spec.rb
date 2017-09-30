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
  valid_attributes = { email: "user@example.com",
                       password: "foobar",
                       password_confirmation: "foobar" }

  let(:company) { build_stubbed(:company) }
  let(:user) { company.users.build(valid_attributes) }

  subject { user }

  it { should be_valid }
  it "should have a valid factory" do
    factory_user = FactoryGirl.build(:user)
    expect(factory_user).to be_valid
  end

  describe "attributes" do
    it { should have_db_column(:email) }
    it { should have_db_column(:password_digest) }
    it { should have_db_column(:remember_token) }
    it { should have_db_column(:company_id) }
    it { should have_db_column(:activated) }
    it { should have_db_column(:activated_at) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
  end

  describe "associations" do
    it { should respond_to :company }
  end

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_length_of(:password).is_at_least(6) }
    it { should validate_confirmation_of(:password) }
    it { should validate_presence_of(:password_confirmation) }

    it "should validate format of e-mail" do
      valid = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      invalid = %w[user@foo,com user_at_foo.org example.user@foo.
                   foo@bar_baz.com foo@bar+baz.com]

      valid.each do |valid_address|
        expect(user).to allow_value(valid_address).for(:email)
      end

      invalid.each do |invalid_address|
        expect(user).not_to allow_value(invalid_address).for(:email)
      end
    end
  end

  describe "callbacks" do
    context "before create" do
      it "sends account activation email" do
        expect {
          user.save
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end
  end

  describe "methods" do
    describe ".authenticated?" do
      it "returns true if given token matches digest" do
        user.save
        token = user.activation_token
        # .authenticated? takes 2 arguments: digest root name, matching token
        expect(user.authenticated?("activation", token)).to be true
        expect(user.authenticated?("activation", "wrong token")).to be false
        user.activation_digest = nil
        expect(user.authenticated?("activation", token)).to be false
      end
    end

    describe ".activate" do
      it "activates a user account" do
        user.save
        user = User.last # Dumps non-persistent attributes
        expect(user.activated).to be false
        expect(user.activated_at).to be nil
        user.activate
        user.reload # Ensure database is updated
        expect(user.activated).to be true
        expect(user.activated_at.class).to be ActiveSupport::TimeWithZone
      end
    end

    describe ".send_activation_email" do
      it "sends account activation email when user is created" do
        expect(user.activation_token).to be nil
        expect(user.activation_digest).to be nil
        expect {
          user.send_activation_email
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
        expect(user.activation_token).not_to be_blank
        expect(user.activation_digest).not_to be_blank
        digest = BCrypt::Password.new(user.activation_digest)
        expect(digest.is_password?(user.activation_token)).to be true
      end

      it "updates activation_digest when resending activation email" do
        user.save
        old_digest = user.activation_digest
        user.send_activation_email
        user.reload
        new_digest = user.activation_digest
        expect(new_digest).not_to eq old_digest
      end

      it "doesn't save the user if it hasn't been created yet" do
        user.send_activation_email
        expect(user.new_record?).to be true
      end
    end

    describe "create_remember_token" do
      before { user.save }
      it "creates remember remember" do
        expect(user.remember_token).not_to be_blank
      end
    end

    describe "#send_password_reset_email" do
      it "sends password_reset message to UserMailer" do
        # Create a double for email, then verify the the correct messages are
        # sent to the UserMailer.
        user.save
        email = double("UserMailer.password_reset")

        expect(UserMailer).to receive(:password_reset).with(user) { email }
        expect(email).to receive(:deliver_now)

        user.send_password_reset_email
      end

      it "persists password reset data" do
        user.save

        expect {
          user.send_password_reset_email
          user.reload
        }.to change { user.password_reset_token }
          .and change { user.password_reset_digest }
          .and change { user.password_reset_sent_at }
      end

      it "creates a token that encrypts to digest" do
        user.save

        user.send_password_reset_email

        digest = BCrypt::Password.new(user.password_reset_digest)
        expect(digest.is_password?(user.password_reset_token)).to be true
      end

      context "when requesting new password reset" do
        it "updates password_reset data" do
          user.save
          user.send_password_reset_email

          expect {
            user.send_password_reset_email
          }.to change { user.password_reset_digest }
        end
      end
    end

    describe "::new_token" do
      # This private method gets tested for security assurance
      it "returns a random token" do
        token = User.new_token
        expect(token.class).to eq String
        expect(token.length).to eq 22
        another_token = User.new_token
        expect(another_token).not_to eq token
      end
    end

    describe "::digest" do
      # This private method gets tested for security assurance
      it "returns hash digest of a given string" do
        digest = User.digest('random string')
        expect(digest.length).to eq 60
        expect(digest.to_s[0..3]).to eq "$2a$"
        another_digest = User.digest('random string')
        expect(another_digest).not_to eq digest
      end
    end
  end
end
