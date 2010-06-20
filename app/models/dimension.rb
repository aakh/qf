# == Schema Information
# Schema version: 20100614023756
#
# Table name: dimensions
#
#  id            :integer         not null, primary key
#  name          :string(255)
#  desc          :string(255)
#  ideal         :float           default(0.0)
#  weight        :float           default(0.0)
#  valuable_id   :integer
#  valuable_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Dimension < ActiveRecord::Base
  belongs_to :valuable, :polymorphic => true
  has_and_belongs_to_many :concepts
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :valuable_type, :case_sensitive => false
   
  before_validation :capitalize
  
  def capitalize
    @attributes['name'].capitalize!
  end
  
  def <=>(dim) # Comparison operator for sorting
    name <=> dim.name
  end
  
  def self.facts
    Dimension.all :conditions => "valuable_type = 'Fact'"
  end
  
  def self.opinions
    Dimension.all :conditions => "valuable_type = 'Opinion'"
  end
  
end
