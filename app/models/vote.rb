class Vote < ActiveRecord::Base
  belongs_to :poll, :counter_cache => true
  belongs_to :choice, :counter_cache => true
end
