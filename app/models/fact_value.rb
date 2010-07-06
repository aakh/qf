# == Schema Information
# Schema version: 20100705154452
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
  
  def self.get_value(fact, entity)
    FactValue.find_by_fact_id_and_entity_id( fact.id, entity.id )
  end
  
  def templatize
    fact.template.gsub("#", value.to_s.sub(/\.0.?/, ''))
    #Changed value type to string, above was just for float
    if fact.dimension.bool?
      return fact.dimension.name + " <b>#{value == 1 ? "Yes" : "No"}</b>"
    end
    fact.template.gsub(/#/, value.to_s)
  end
end
