require 'rails_helper'

describe EmailDigestCreator, :not_a_tenant_model do
  it 'updates the users email_digest' do
    user = User.find(create(:user).id)
    token = SecureRandom.urlsafe_base64

    EmailDigestCreator.new(user, token).call
    user.email_digest = nil
    user.reload

    expect(user.email_digest).not_to be_nil
  end
end
