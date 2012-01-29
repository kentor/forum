class Poll < ActiveRecord::Base
  has_many :votes
  has_many :choices
  accepts_nested_attributes_for :choices
  
  validates :name, :presence => true, :length => { :maximum => 70 }
  validate  :number_of_choices

  def voted?(ip)
    votes.where(:ip => ip).any?
  end
  
  def number_of_choices
    unless self.choices.select { |c| c.name.present? }.length.between?(2,12)
      self.errors.add(:base, "Must have between 2 and 12 options")
    end
  end
end
