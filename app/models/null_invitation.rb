class NullInvitation
  def send_invitation_email
  end

  def invitation_sent_at
    Time.zone.local(1900)
  end

  def invitation_expired?
    true
  end
end
