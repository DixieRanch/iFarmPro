class NullUser
  def send_password_reset_email
  end

  def authenticated?(_, _)
  end

  def password_reset_sent_at
    Time.zone.local(1900)
  end
end
