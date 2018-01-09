class UserInvitation < ActiveRecord::Base
  belongs_to :company

  attr_accessor :invitation_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX }

  validate :unique_email

  def unique_email
    errors.add(:email, 'is already being used') if User.where(
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

  private

  def create_invitation_digest
    self.invitation_token  = UserInvitation.new_token
    self.invitation_digest = UserInvitation.digest(invitation_token)
  end
end
