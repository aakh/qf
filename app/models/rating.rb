# == Schema Information
# Schema version: 20100705154452
#
# Table name: ratings
#
#  id         :integer         not null, primary key
#  value      :float
#  entity_id  :integer
#  user_id    :integer
#  opinion_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :entity
  belongs_to :opinion
  validates_presence_of :value
  
  def self.get_value(user, entity, op)
    r = self.find_by_user_id_and_entity_id_and_opinion_id user, entity, op
    r ? r.value : nil
  end
  
  def self.entity_count(entity)
    Rating.count :select => "DISTINCT user_id", :conditions => "entity_id = #{entity.id}"
  end
  
  def self.user_count(user)
    Rating.count :select => "DISTINCT entity_id", :conditions => "user_id = #{user.id}"
  end
end
