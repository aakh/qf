# == Schema Information
# Schema version: 20100705154452
#
# Table name: concepts
#
#  id         :integer         not null, primary key
#  name       :string(255)     not null
#  desc       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Concept < ActiveRecord::Base
  validates_presence_of :name
  validates_length_of :name, :within => 2..255
  validates_length_of :desc, :maximum => 1000
  has_many :entities, :dependent => :destroy, :order => :name
  validates_uniqueness_of :name, :case_sensitive => false
  has_and_belongs_to_many :dimensions
  
  def fact_dimensions
    dimensions.find_all { |dim| dim.valuable_type == "Fact" and dim.enabled? }.sort
  end
  
  def opinion_dimensions
    dimensions.find_all { |dim| dim.valuable_type == "Opinion" and dim.enabled? }.sort
  end
  
  # If user passed in then local ideal candidate is used
  def sorted_entities(user = nil)
    entities.select do |e|
      e.num_dims_used = 0;
      if e.rated_yet?
        n, d = e.get_distance_from_ideal user
        e.distance = d
        e.num_dims_used = n
      end
      true
    end.sort
  end
end
