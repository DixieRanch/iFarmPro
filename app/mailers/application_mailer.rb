class ApplicationMailer < ActionMailer::Base
  default from: "noreply@ifarmpro.com", to: "no_one@example.com"
  layout 'mailer'
end