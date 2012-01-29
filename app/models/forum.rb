class Forum < ActiveRecord::Base
  acts_as_list
  
  has_many :topics, :order => 'sticky desc, last_posted_at desc'
  
  validates :title, :presence => true
  
  default_scope order('position asc')
  
  def recent_threads
    topics.list.order('sticky desc, created_at desc').limit(threads_in_index)
  end
  
  def can_view
    allowed_to_view
  end
  
  def can_read
    allowed_to_read.blank? ? can_view : allowed_to_read
  end
  
  def can_reply
    allowed_to_reply.blank? ? can_read : allowed_to_reply
  end
  
  def can_create
    allowed_to_create.blank? ? can_reply : allowed_to_create
  end
end
