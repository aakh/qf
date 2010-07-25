# == Schema Information
# Schema version: 20100705154452
#
# Table name: opinions
#
#  id           :integer         not null, primary key
#  low_text     :string(255)     default("low")
#  high_text    :string(255)     default("high")
#  total_ideal  :float           default(0.0)
#  num_ideals   :integer         default(0)
#  total_weight :float           default(0.0)
#  num_weights  :integer         default(0)
#  created_at   :datetime
#  updated_at   :datetime
#

class Opinion < ActiveRecord::Base
  has_one :dimension, :as => :valuable, :dependent => :destroy
  accepts_nested_attributes_for :dimension
  
  validates_presence_of :low_text, :high_text
  validates_length_of :low_text, :maximum => 10
  validates_length_of :high_text, :maximum => 10
  
  before_validation :analyze_attributes
  
  def analyze_attributes
    @attributes['low_text'].capitalize!
    @attributes['high_text'].capitalize!
  end
  
  def self.find_by_name(name)
    dim = Dimension.find_by_name_and_valuable_type(name, 'Opinion')
    dim.valuable if dim
  end
  
  has_many :ratings, :dependent => :destroy
  has_many :users, :through => :ratings
  has_many :entities, :through => :ratings
  
  has_many :current_ratings, :dependent => :destroy
  has_many :entities, :through => :current_ratings
  
  has_many :beliefs, :dependent => :destroy
  has_many :users, :through => :beliefs
  
  def weight
    w = self.num_weights > 0 ? (self.total_weight / self.num_weights) : 5
  end
  
  def ideal
    val = nil
    if self.num_ideals > 0
      val = self.total_ideal / self.num_ideals
      
      # Tranform range [0,1] into range [1,5] if boolean dimension
      if dimension.bool?
        val = val * 4 + 1
      end
    end
    val
  end
end
