class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :recipient, :class_name => 'User'

  validates :subject, :presence => true, :length => { :maximum => 50 }
  validates :body, :presence => true
  
  default_scope order('id desc')
end
