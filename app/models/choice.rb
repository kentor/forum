class Choice < ActiveRecord::Base
  belongs_to :poll
  has_many :votes
  
  validates :name, :presence => true, :length => { :maximum => 100 }
  
  def percent(poll = self.poll)
    if votes.size.zero?
      0
    else
      votes.size.to_f / poll.votes.size * 100
    end.round.to_s + "%"
  end
  
  def width(poll = self.poll)
    if votes.size.zero?
      1
    else
      4.5 * votes.size.to_f / poll.votes.size * 100
    end.round.to_s + "px"
  end
end
