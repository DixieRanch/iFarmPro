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
end
