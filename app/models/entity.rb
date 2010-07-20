# == Schema Information
# Schema version: 20100705154452
#
# Table name: entities
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  desc               :text
#  concept_id         :integer
#  created_at         :datetime
#  updated_at         :datetime
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#

class Entity < ActiveRecord::Base
  has_many :comments, :as => :commentable, :dependent => :destroy
  belongs_to :concept
  
  has_many :fact_values, :dependent => :destroy
  has_many :facts, :through => :fact_values
  
  validates_presence_of :name, :concept, :price
  has_attached_file :photo, #:styles => { :thumb => "100x100>" },
                    :url  => "/images/entities/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/images/entities/:id/:style/:basename.:extension"
  
  # validates_attachment_presence :photo
  #validates_attachment_size :photo, :less_than => 5.megabytes
  #validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  validates_uniqueness_of :name, :scope => :concept_id, :case_sensitive => false
  
  before_validation :fix_name
  
  def fix_name
    @attributes['name'] = @attributes['name'].titleize
  end
  
  attr_accessor :price
  
  has_many :ratings, :dependent => :destroy
  has_many :users, :through => :ratings
  has_many :opinions, :through => :ratings
  
  has_many :current_ratings, :dependent => :destroy
  has_many :opinions, :through => :current_ratings
  
  attr_accessor :distance, :num_dims_used
  
  def <=>(ent) # Comparison operator for sorting, only works when distance accessor is set
    return self.name <=> ent.name unless num_dims_used and ent.num_dims_used
    return 1 if num_dims_used == 0 and ent.num_dims_used > 0
    return -1 if num_dims_used > 0 and ent.num_dims_used == 0
    return 0 if num_dims_used == 0 and ent.num_dims_used == 0
    a_percent = Integer((@num_dims_used - @distance) * (100.0 / @num_dims_used))
    b_percent = Integer((ent.num_dims_used - ent.distance) * (100.0 / ent.num_dims_used))
    b_percent <=> a_percent
  end
  
  def get_distance_from_ideal(user = nil)
    get_distance_from nil, user
  end
  
  def get_distance_from(other, user)
    dist = 0
    num_dims_used = 0

    self.concept.opinion_dimensions.each do |dim|
      
      # If this dimension has been disabled, then carry on to next
      next unless dim.enabled?
      
      # If this dimension has not been rated then ignore it
      next unless rating = rating_for(dim)
      
      opinion = dim.valuable
      
      # If user supplied then we want to use the user's ideal value and weight
      # else we use the global one
      if user
        ideal, weight = user.get_ideal_and_weight_for opinion
      else
        # If other supplied then we need to calculate distance between
        # this entity and 'other' entity, so use other.rating as ideal
        if other
          ideal = other.rating_for dim
        else
          # Use global ideal value
          ideal = opinion.ideal
        end
        
        # Use global weight
        weight = opinion.weight
      end
      
      # If we don't have an ideal at this point then go to next value dimension
      next unless ideal
      
      # if weight is "I don't care" (i.e. 1) then this dimension should be ignored
      next if weight == 1
      
      # Transform weights from [2,5] into [0,1]
      weight = (weight - 2) / 3
      
      # Values all in the range of 1 to 5.
      min = 1
      max = 5
      
      # This takes into account situations where ideal is not either 1 or 5 so the
      # max and min becomes different. If ideal is 3 for example, then the maximum 
      # difference between the ideal and the actual rating can be 2 (instead of 4
      # when using the range [1,5])
      
      # right = 5 - ideal
      # left = ideal - 1
      # max = right > left ? right : left
      # if rating > ideal
        # min = ideal
        # max = ideal + max
      # else
        # min = ideal - max
        # max = ideal
      # end
      
      x = (min - rating) / (min - max)
      y = (min - ideal) / (min - max)
      num_dims_used += 1
      
      # If rating is the same as ideal then rating is perfect!
      next if x == y
      
      # calculate distance between rating and ideal and add it to total_distance
      x *= weight
      y *= weight
      dist += 0.5 * (1 + (x - y).abs - (1 - x - y).abs)
    end
    
    # The max distance is never bigger than the number of dimensions used
    # in the caluclation since the max distance for each of ratings from
    # the ideal is 1.
    # We return both so we can display a bar graph depicting a rating instead 
    # of just a distance.
    return num_dims_used, dist
  end
  
  private
  
  def rating_for(dim)
    # If it's a boolean then this entity either has it or doesn't
    # Retirn 0|1 in the range of 1|5
    if dim.bool?
      fv = FactValue.get_value(Fact.find_by_name(dim.name), self)
      return fv.value * 4 + 1 if fv
    else
      cr = CurrentRating.find_by_entity_id_and_opinion_id(self, dim.valuable)
      return cr.rating if cr
    end
    nil
  end
end
