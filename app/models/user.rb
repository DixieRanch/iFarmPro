# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  email             :string
#  created_at        :datetime
#  updated_at        :datetime
#  password_digest   :string
#  remember_token    :string
#  company_id        :integer
#  activation_digest :string
#  activated         :boolean          default(FALSE)
#  activated_at      :datetime
#

class User < ActiveRecord::Base
  has_secure_password

  belongs_to :company

  attr_accessor :activation_token, :email_token

  before_save :create_remember_token

  after_create :send_activation_email

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, allow_nil: true

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

  def self.with_email(email)
    where('lower(email) = ?', email.downcase).first || NullUser.new
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    return if activated?
    update_attributes(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    create_activation_digest
    UserMailer.account_activation(self).deliver_now
  end

  def send_password_reset_email
    create_password_reset_digest
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    password_reset_sent_at < 2.hours.ago
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  def create_activation_digest
    self.activation_token = User.new_token
    EmailDigestCreator.call(self, activation_token)
  end

  def create_password_reset_digest
    self.email_token = User.new_token
    EmailDigestCreator.call(self, email_token)
    self.password_reset_sent_at = Time.zone.now
    update_attributes(password_reset_sent_at: password_reset_sent_at)
  end

  def create_email_digest
  end
end
