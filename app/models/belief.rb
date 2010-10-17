# == Schema Information
# Schema version: 20100705154452
#
# Table name: beliefs
#
#  id         :integer         not null, primary key
#  ideal      :float
#  weight     :float
#  opinion_id :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Belief < ActiveRecord::Base
  belongs_to :user
  belongs_to :opinion
  
  def similarity_to(other, use_calude = false)    
    i1 = ideal
    i2 = other.ideal
    
    # Change boolean ideals from range [0,1] to [1,5]
    if opinion.dimension.bool?
      i1 = i1 * 4 + 1 
      i2 = i2 * 4 + 1
    end
    
    d1 = i1 / 5.0
    d2 = i2 / 5.0
    
    sim = 1.0 - (d2 - d1).abs
    
    # Modify similarity by how close the weights are
    # If weights are the same then sim stays the same as above
    # If weight is not specified, consider it "I don't care"
    w1 = weight ? weight : 1
    w2 = other.weight ? other.weight : 1
    
    # Dist(x,y) != Dist(y,x) ????
    if use_calude
      return (1 - Dimension.distance( i1, i2, 0)) + (1 - Dimension.distance(w1, w2, 0))
    end
      #return 1 - (Dimension.distance( i2 * w2, i1 * w1, 5))
    
    w1 /= 5.0
    w2 /= 5.0
    
    w = 1.0 - (w1 - w2).abs
    
    sim *= w
    
    # What's this? Which one should I use??
    # i1 > i2 ? ((i2 / i1) * w) : ((i1 / i2) * w)
  end
  
end
