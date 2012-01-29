module AnnouncementsHelper
  def announcement
    a = Announcement.where(:live => true).first
    bb a.message, :smilies => false, :html => true if a
  end
end
