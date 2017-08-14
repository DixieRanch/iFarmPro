require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.account_activation(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("iFarmPro account activation")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@ifarmpro.com"])
    end

    it "renders the body" do
      # expect(mail.body.encoded).to include activation link
    end
  end
end