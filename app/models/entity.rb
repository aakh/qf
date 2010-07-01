# == Schema Information
# Schema version: 20100623234744
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
    a_percent = Integer((@num_dims_used - @distance) * (100 / @num_dims_used))
    b_percent = Integer((ent.num_dims_used - ent.distance) * (100 / ent.num_dims_used))
    b_percent <=> a_percent
  end
  
  def get_distance_from_ideal()
    get_distance_from nil
  end
  
  def get_distance_from(other)
    dist = 0
    num_dims_used = 0
    self.concept.opinion_dimensions.each do |dim|
      #For each dimension that this entity can be rated over
      # Get ideal and weight value
      # Get rating for this entity over the dimension
      # Get percentage of rating within ideal
      opinion = dim.valuable
      
      weight = opinion.total_weight / opinion.num_weights
      
      # If no ideal then there's nothing to calculate the distance from, carry on
      if other
        ideal = other.get_rating_for dim
        next unless ideal
      else
        ideal = opinion.total_ideal / opinion.num_ideals
        next unless opinion.num_ideals > 0
      end
      
      # if weight is I don't care then this dimension should be ignored
      next if weight == 1
      
      weight = 4 unless opinion.num_weights > 0
      weight = (weight - 1) / 4

      next unless rating = get_rating_for(dim)
      
      # Put in range of [1,4] if it's a boolean type
      if dim.bool?
        ideal = ideal * 4 + 1
        rating = rating * 4 + 1
      end

      # Simple distance calculation
      # dist += ((ideal - rating).abs + 1) * weight
      
      x = (1 - rating) / (1 - 5)
      y = (1 - ideal) / (1 - 5)
      num_dims_used += 1
      
      next if x == y
      
      x *= weight
      y *= weight
      dist += 0.5 * (1 + (x - y).abs - (1 - x - y).abs)
    end
    return num_dims_used, dist
  end
  
  private
  
  def get_rating_for(dim)
    if dim.bool?
      fv = FactValue.get_value(Fact.find_by_name(dim.name), self)
      return nil unless fv
      if fv then fv.value else nil end
    else
      cr = CurrentRating.find_by_entity_id_and_opinion_id(self, dim.valuable)
      # If this dimension doesn't have a rating then carry on with the next.
      return nil unless cr
      if cr.num_ratings > 0 then cr.total_rating / cr.num_ratings else nil end
    end
  end
end
