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
      expect(mail).to have_selector 'h1', text: 'Welcome to iFarmPro!'
      expect(mail).to have_link 'Activate', href: edit_account_activation_url(
                                                  user.activation_token, 
                                                  email: user.email)
      expect(mail.body.encoded).to have_selector 'p', text: user.email
    end
  end
end