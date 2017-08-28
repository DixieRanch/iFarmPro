class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @message = "Thanks for signing up #{user.email} for iFarmPro!  " + 
               "Please click the following link to activate your account " +
               "and finish the signup process."
    @user = user
    mail to: user.email, 
    subject: "iFarmPro account activation"
  end
  
  def password_reset
    mail
  end
end