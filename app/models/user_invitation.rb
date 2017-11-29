class UserInvitation < ActiveRecord::Base
  belongs_to :company

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX }

  def send_invitation_email
    UserMailer.invitation(self).deliver_now
  end
end
