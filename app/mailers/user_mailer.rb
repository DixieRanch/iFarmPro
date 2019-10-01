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
    @message = "Hello, #{user.email}.  This email is to allow you to finish " \
               'setting up your account for iFarmPro irrigation management. ' \
               'Click the link to finish signing up, and then you will have ' \
               "full access to your company's irrigation schedule."
    @user = user
    mail to: user.email,
         subject: 'iFarmPro invitation'
  end

  def new_email_verification(user)
    @message = "Hello, #{user.new_email}. Click the link below to verify " \
               'your new email at iFarmPro. This link will stop working after' \
               'two(2) hours. If you did not request to change your iFarmPro ' \
               'email, then please discard this email.'
    @user = user
    mail to: user.new_email,
         subject: 'iFarmPro new email verification'
  end

  def current_email_verification(user)
    @message = 'STOP! If you did not request to change your iFarmPro email ' \
               "or you have not yet verified #{user.new_email}. DO NOT click " \
               'the link below. Delete this email and contact iFarmPro. If' \
               'you requested an email change at iFarmPro, click the link ' \
               "below to verify the control of and change to #{user.new_email}."
    @user = user
    mail to: user.email,
         subject: 'iFarmPro current email verification'
  end
end
