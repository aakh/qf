class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :entity
  belongs_to :opinion
  validates_presence_of :value
  
  def self.get_value(user, entity, op)
    r = self.find_by_user_id_and_entity_id_and_opinion_id user, entity, op
    r ? r.value : nil
  end
end
