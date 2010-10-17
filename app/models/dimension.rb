# == Schema Information
# Schema version: 20100705154452
#
# Table name: dimensions
#
#  id            :integer         not null, primary key
#  name          :string(255)
#  desc          :string(255)
#  bool          :boolean
#  valuable_id   :integer
#  valuable_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Dimension < ActiveRecord::Base
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  belongs_to :valuable, :polymorphic => true
  has_and_belongs_to_many :concepts
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :valuable_type, :case_sensitive => false
   
  before_validation :analyze_attributes
  after_save :create_opinion_if_fact
  attr_writer :op_name
  
  def analyze_attributes
    if @attributes['name'] 
      @attributes['name'].capitalize!
      @attributes['name'].strip!
      
      #If name has a question mark at the end (spaces should not be there after strip!)
      if @attributes['name'] =~ /\?\Z/
        @attributes['bool'] = true
      end
    end
  end
  
  def <=>(dim) # Comparison operator for sorting
    name <=> dim.name
  end
  
  def self.fact_dimensions
    Dimension.all :conditions => "valuable_type = 'Fact'", :order => "name"
  end
  
  def self.opinion_dimensions
    Dimension.all :conditions => "valuable_type = 'Opinion'", :order => "name"
  end
  
  def type_s
    return "boolean" if bool?
    "ordinal"
  end
  
  # Create an opinion that goes along with the fact.
  def create_opinion_if_fact
    if valuable_type == 'Fact'
      op = Opinion.find_by_name name

      unless op
        op = Opinion.new
        op.dimension = Dimension.new :name => name
      end
      
      #op.dimension.update_attributes :name => name, :desc => desc
      op.dimension.name = name
      op.dimension.desc = desc
      
      # Give the opinions the same associations as the fact
      # with the migrations this table is not created when the default
      # facts are added in
      if connection.tables.include? "concepts_dimensions"
        op.dimension.concepts.clear
        
        concepts.each do |c|
          op.dimension.concepts << c
        end
      end
      
      op.save
    end
  end
  
  def self.distance(rating, ideal, weight)
    # rating [1,5]
    # ideal [1,5]
    # weight [1,5]
    
    # Values all in the range of 1 to 5.
    min = 1
    max = 5
    
    #weight /= 5
    #weight / 
    
    # This takes into account situations where ideal is not either 1 or 5 so the
    # max and min becomes different. If ideal is 3 for example, then the maximum 
    # difference between the ideal and the actual rating can be 2 (instead of 4
    # when using the range [1,5])
    # This allows things to be as bad as possible because if the ideal is 2.5 and 
    # the rating is 5, that's as bad as it can get, but without this modification
    # the algorithim assumes the rating is 2.5 points away in a range of [1,5] so 
    # that leaves wiggle room. With this modification, the rating is 2.5 points
    # away in a range of [2.5, 5]
    
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
    
    # If rating is the same as ideal then rating is perfect!
    return 0 if x == y
    
    # calculate distance between rating and ideal and add it to total_distance
    # NOTE: If the weight is not vital (1) then even if the rating is as far apart
    # from the ideal as possible (also 1) then distance gets some value in it
    # Is this what is supposed to happen???
    # So this means if it has a high rating on a dimension that matters a lot it will
    # get farther away from the ideal than on a dimension that matters a little... Sounds good!
    #x *= (weight)
    #y *= (weight)
    
    return (1 - weight)*(0.5 * (1 + (x - y).abs - (1 - x - y).abs))
  end
  
end
