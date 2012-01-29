class Warning < ActiveRecord::Base
  belongs_to :user
  belongs_to :warner, :class_name => 'User'
  belongs_to :post
end

