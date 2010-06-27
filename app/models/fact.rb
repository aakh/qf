# == Schema Information
# Schema version: 20100623234744
#
# Table name: facts
#
#  id         :integer         not null, primary key
#  template   :string(255)     default("#")
#  created_at :datetime
#  updated_at :datetime
#

class Fact < ActiveRecord::Base
  has_one :dimension, :as => :valuable, :dependent => :destroy
  accepts_nested_attributes_for :dimension
  
  has_many :fact_values, :dependent => :destroy
  has_many :entities, :through => :fact_values
  
  def self.find_by_name(name)
    dim = Dimension.find_by_name_and_valuable_type( name, 'Fact')
    return dim.valuable if dim
  end
end
