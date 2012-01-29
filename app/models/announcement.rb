class Announcement < ActiveRecord::Base
  validates :message, :presence => true
  
  before_create :turn_off_live, :if => "live?"
  
  def turn_off_live
    Announcement.update_all("live = false", "live = true")
  end
end
