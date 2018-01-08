class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @message = "Thanks for signing up #{user.email} for iFarmPro!  " \
               'Please click the following link to activate your account ' \
               'and finish the signup process.'
    @user = user
    mail to: user.email,
         subject: 'iFarmPro account activation'
  end

  def password_reset(user)
    @message = "Hello, #{user.email}.  Click the link below to reset your " \
               'password at iFarmPro.  This link will stop working after ' \
               'two(2) hours. If you did not request to reset your iFarmPro ' \
               'password, then you may be at risk.'
    @user = user
    mail to: user.email,
         subject: 'iFarmPro password reset'
  end

  def invitation(user)
    mail to: user.email,
         subject: 'iFarmPro invitation'
  end
end
