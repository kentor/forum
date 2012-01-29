class Topic < ActiveRecord::Base
  belongs_to :forum
  belongs_to :user
  belongs_to :last_poster, :class_name => 'User'
  has_many :posts, :dependent => :destroy
  
  validates :title, :presence => true, :length => { :maximum => 50 }
  
  def status(hot = 1.hour.ago)
    case
    when sticky? && locked? then 'stickylock.png'
    when hot? && locked?    then 'hotlock.png'
    when locked?            then 'lock.png'
    when sticky?            then 'sticky.png'
    when hot?               then 'hot.png'
    else 'regular.png'
    end
  end
  
  def hot?(time = 1.hour.ago)
    last_posted_at >= time
  end
  
  def replies
    (posts.size-1).to_s
  end
  
  def total_pages
    (posts.size.to_f / 20).ceil
  end
  
  def last_post_time
    last_posted_at.strftime("%b %d %Y %H:%M")
  end
  
  def increment_views
    Topic.record_timestamps = false
    increment!(:views, 1)
    Topic.record_timestamps = true
  end
  
  def self.list
    includes(:user).includes(:last_poster)
  end
  
  def self.search(q)
    query = "%#{q}%"
    where("title like ?", query)
  end
  
  def self.forum_id(ids)
    where("topics.forum_id in (?)", ids)
  end
end
