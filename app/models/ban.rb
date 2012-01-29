class Ban < ActiveRecord::Base
  belongs_to :user
  belongs_to :banner, :class_name => 'User'
  belongs_to :post
  
  after_create :add_ban_to_user
  
  private
  
  def add_ban_to_user
    user.ban
  end
end
