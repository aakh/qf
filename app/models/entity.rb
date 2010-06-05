# == Schema Information
# Schema version: 20100605101028
#
# Table name: entities
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  desc       :text
#  concept_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Entity < ActiveRecord::Base
  belongs_to :concept
  validates_presence_of :name, :concept
end
