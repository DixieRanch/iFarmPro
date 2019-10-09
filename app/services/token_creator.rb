class TokenCreator
  def self.call
    SecureRandom.urlsafe_base64
  end
end
