# == Schema Information
# Schema version: 20100614023756
#
# Table name: fact_values
#
#  id         :integer         not null, primary key
#  value      :float
#  fact_id    :integer
#  entity_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class FactValue < ActiveRecord::Base
  belongs_to :entity
  belongs_to :fact
  
  validates_presence_of :value
  
  def self.get_value(dim, entity)
    FactValue.find_by_fact_id_and_entity_id( dim.valuable.id, entity.id )
  end
end
