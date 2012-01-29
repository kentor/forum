class Login < ActiveRecord::Base
  belongs_to :user
  
  def self.recent(time = 30.days.ago)
    where("created_at >= ?", time)
  end
end
