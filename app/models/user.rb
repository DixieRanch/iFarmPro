# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string
#  created_at      :datetime
#  updated_at      :datetime
#  password_digest :string
#  remember_token  :string
#  company_id      :integer
#

class User < ActiveRecord::Base
  has_secure_password

  belongs_to :company

  before_save :create_remember_token
    
  attr_accessor :activation_token
  # before_save   :downcase_email
  before_create :create_activation_digest

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :email, presence: true, 
                    format: { with:VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  # validates :activation_digest, presence: true
  # validates :activation_token, presence: true
  
  # Returns hash digest of a given string
  def User.digest(string)
    # establish cost
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine::cost
    # create hash digest
    BCrypt::Password.create(string, cost: cost)
  end
  
  # Returns true if given token matches digest
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # Returns random token
  def self.new_token
    SecureRandom.urlsafe_base64
  end
  
  # Activates a user account
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end
  
  # Sends account activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # Creates and assigns a activation token and digest
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64                     
    end                     
    
    # converts all emails to lowercase
    # def downcase_email
    #   self.email = email.downcase
    # end
    

end
