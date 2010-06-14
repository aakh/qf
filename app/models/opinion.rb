# == Schema Information
# Schema version: 20100613020951
#
# Table name: opinions
#
#  id         :integer         not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class Opinion < ActiveRecord::Base
  has_one :dimension, :as => :valuable
  accepts_nested_attributes_for :dimension
end
