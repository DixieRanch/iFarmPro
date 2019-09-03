class EmailDigestCreator
  def initialize(user, token)
    @user = user
    @token = token
  end

  attr_reader :user, :token

  def self.call(*args)
    EmailDigestCreator.new(*args).call
  end

  def call
    save_email_digest_to_user
  end

  private

  def save_email_digest_to_user
    user.update_attributes(email_digest: create_digest_from_token)
  end

  def create_digest_from_token
    BCrypt::Password.create(token, cost: cost)
  end

  def cost
    if ActiveModel::SecurePassword.min_cost
      BCrypt::Engine::MIN_COST
    else
      BCrypt::Engine.cost
    end
  end
end
