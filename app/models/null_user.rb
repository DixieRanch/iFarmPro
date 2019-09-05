class NullUser
  def send_activation_email
  end

  def send_password_reset_email
  end

  def authenticated?(_, _)
  end

  def email_digest_created_at
    Time.zone.local(1900)
  end

  def password_reset_expired?
    true
  end
end
