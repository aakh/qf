# == Schema Information
# Schema version: 20100705154452
#
# Table name: current_ratings
#
#  id           :integer         not null, primary key
#  total_rating :float           default(0.0)
#  num_ratings  :integer         default(0)
#  entity_id    :integer
#  opinion_id   :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class CurrentRating < ActiveRecord::Base
  belongs_to :entity
  belongs_to :opinion
  
  def rating
    if self.num_ratings > 0 
      self.total_rating / self.num_ratings
    else
      nil
    end
  end
end
