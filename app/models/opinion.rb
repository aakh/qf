# == Schema Information
# Schema version: 20100614023756
#
# Table name: opinions
#
#  id         :integer         not null, primary key
#  min        :float           default(0.0)
#  max        :float           default(1.0)
#  created_at :datetime
#  updated_at :datetime
#

class Opinion < ActiveRecord::Base
  has_one :dimension, :as => :valuable, :dependent => :destroy
  accepts_nested_attributes_for :dimension
  
  def self.find_by_name(name)
    dim = Dimension.find_by_name_and_valuable_type(name, 'Opinion')
    dim.valuable if dim
  end
end
