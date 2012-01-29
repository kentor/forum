class Post < ActiveRecord::Base
  belongs_to :user, :counter_cache => true
  belongs_to :topic, :counter_cache => true
  
  validates :body, :presence => true

  after_create :insert_last_info
  after_destroy :shift_sub_id
  
  def nuke
    toggle!(:nuked)
  end
  
  def warn
    toggle!(:warned)
  end
  
  def warn!
    update_attribute(:warned, true)
  end
  
  def ban
    toggle!(:banned)
  end
  
  def ban!(options = {})
    options.reverse_merge! :temporary => true
    update_attributes(:banned => true, :temp_banned => options[:temporary])
  end
  
  def page
    (sub_id.to_f / 20).ceil
  end
  
  def self.search(q)
    query = "%#{q}%"
    where("body like ?", query)
  end
  
  def self.topic_id(ids)
    where("topic_id in (?)", ids)
  end
  
  def self.sub_id(id)
    where(:sub_id => id)
  end
  
  private
  
  def insert_last_info
    self.modified_at = created_at
    topic.last_posted_at = created_at
    topic.last_poster_id = user_id
    self.save && topic.save
  end

  def shift_sub_id
    topic.posts.update_all("sub_id = sub_id - 1", ["sub_id > ?", self.sub_id])
  end
end
