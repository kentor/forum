class Session < ActiveRecord::Base
  def self.active_users(time = 15.minutes.ago)
    where("updated_at >= ?", time).size
  end
  
  def self.touch_active_users(ip)
    find_or_create_by_ip(ip).touch
  end
end
