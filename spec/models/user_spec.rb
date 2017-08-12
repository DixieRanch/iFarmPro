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

    # it "should be save email as all lower-case" do
    #   mixed_case_email = "Foo@ExAMPle.CoM"
    #   user.email = mixed_case_email
    #   user.save
    #   user.reload.email.should == mixed_case_email.downcase
    # end
  end

  describe "methods" do
    describe "create_remember_token" do
      before { user.save }
        it "creates remember remember" do
          expect(user.remember_token).not_to be_blank
        end
    end
    
    describe "create_activation_digest" do
      before { user.save }
        it "creates activation token" do
          expect(user.activation_token).not_to be_blank
        end
        it "creates activation digest" do
          expect(user.activation_digest).not_to be_blank
        end
    end
  end
end
