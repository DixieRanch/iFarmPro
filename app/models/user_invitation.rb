class UserInvitation < ActiveRecord::Base
  belongs_to :company
<<<<<<< 6e55af07c97f9d40cd3f1c4386d5865b9376e890
<<<<<<< 4758e59549eaaeba3177098b8ebac53797e7e52d

  attr_accessor :invitation_token
=======
>>>>>>> Add email validations to UserInvitation

  attr_accessor :invitation_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true,
<<<<<<< 20f7fe3d10b0df4b1e933cc4c94cd30da49067f9
                    format: { with: VALID_EMAIL_REGEX }
<<<<<<< 514d7a64f4922a568459ce36ddb7b7e1327cfd75
<<<<<<< 6e55af07c97f9d40cd3f1c4386d5865b9376e890
=======
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
>>>>>>> Add uniqueness validations for UserInvitation objects.

  validate :unique_email

  def unique_email
    errors.add(:email, 'This email already belongs to a user.') if User.where(
      email: email
    ).exists?
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end

    BCrypt::Password.create(string, cost: cost)
  end

  def send_invitation_email
    create_invitation_digest
    UserMailer.invitation(self).deliver_now
  end

  def invitation_expired?
    invitation_sent_at < 7.days.ago
  end

  def self.with_email(email)
    where('lower(email) = ?', email.downcase).first || NullInvitation.new
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  private

  def create_invitation_digest
    self.invitation_token  = UserInvitation.new_token
    self.invitation_digest = UserInvitation.digest(invitation_token)
    self.invitation_sent_at = Time.zone.now
    update_attributes(invitation_sent_at: invitation_sent_at)
  end
=======
>>>>>>> Add link in header for user invitation
=======
>>>>>>> Add email validations to UserInvitation
=======

  validate :unique_email

  def unique_email
    errors.add(:email, 'This email already belongs to a user.') if User.where(
      email: email
    ).exists?
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end

    BCrypt::Password.create(string, cost: cost)
  end

  def send_invitation_email
    create_invitation_digest
    UserMailer.invitation(self).deliver_now
  end
<<<<<<< 82011c504e3e52e4ed318e5f36afe4078ab7b1ca
>>>>>>> Add invitation email delivery method to user_invitation model
=======

  def invitation_expired?
    invitation_sent_at < 7.days.ago
  end

  def self.with_email(email)
    where('lower(email) = ?', email.downcase).first || NullInvitation.new
  end

  private

  def create_invitation_digest
    self.invitation_token  = UserInvitation.new_token
    self.invitation_digest = UserInvitation.digest(invitation_token)
    self.invitation_sent_at = Time.zone.now
    update_attributes(invitation_sent_at: invitation_sent_at)
  end
>>>>>>> Add token/digest for user_invitation
end
