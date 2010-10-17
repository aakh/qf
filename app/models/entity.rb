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
  
  protected
  def percent
    (@num_dims_used - @distance) * (100.0 / @num_dims_used)
  end
  
  public
  # Comparison operator for sorting, if the distance and num_dims_used accessor 
  # is set on both entities before calling this then it is sorted by rating
  # else it is sorted alphabetically.
  def <=>(ent) 
    return self.name <=> ent.name unless num_dims_used and ent.num_dims_used
    return 1 if num_dims_used == 0 and ent.num_dims_used > 0
    return -1 if num_dims_used > 0 and ent.num_dims_used == 0
    return 0 if num_dims_used == 0 and ent.num_dims_used == 0
    ent.percent <=> self.percent
  end
  
  
  def get_distance_from_ideal(user = nil)
    get_distance_from nil, user
  end
  
  def get_distance_from(other, user)
  
    if other && user
      # User has to have some beliefs set for this to work
      if Belief.find_by_user_id(user) == nil
        return nil, nil
      end
      
      # This is a special case. We want the distance similarity between 2 entities
      # based on the user's local stuff. A little extra processing is in order
      
      # If entities are the same then tada
      return 1, 1 if other == self
      
      # Get distance for entity 1 from user's beleif system
      n1, d1 = self.get_distance_from nil, user
      
      # Get distance for entity 2 from user's beleif system
      n2, d2 = other.get_distance_from nil, user
      
      if n1 == 0 || n2 == 0
        # This means the user has no union between his set beliefs
        # and the dimensions rated for this entity and the other entity
        return nil, nil
      end
      
      r1 = d1 / n1
      r2 = d2 / n2
      
      # Don't forget this function has to return a num_dims_used as well.
      # This is in the calculation so let's just set it to 1
      return 1, (r1 - r2).abs
    end
    
    dist = 0
    num_dims_used = 0
    
    wf = 0
    self.concept.opinion_dimensions.each do |dim|
      weight = 0
      if user
        ideal, weight = user.get_ideal_and_weight_for dim.valuable
      else
        weight = dim.valuable.weight
      end
      next if !weight or weight < 1.1
      wf += weight * weight
    end
    
    wf = Math.sqrt(wf)

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
      next if weight < 1.1
      
      dist += Dimension.distance(rating, ideal, weight / wf)
      num_dims_used += 1
    end
    
    # The max distance is never bigger than the number of dimensions used
    # in the caluclation since the max distance for each of ratings from
    # the ideal is 1.
    # We return both so we can display a bar graph depicting a rating instead 
    # of just a distance.
    return num_dims_used, dist
  end
  
  # returns in range [1,5]
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
  
  def rated_yet?
    Rating.find_by_entity_id(self.id) != nil
  end
  
  def get_users_who_rated    
    ratings = Rating.all :conditions => {:entity_id => self.id}, :select => "DISTINCT(user_id)", :include => :user
    ratings.collect {|x| x.user }
  end
end
