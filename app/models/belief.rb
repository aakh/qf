# == Schema Information
# Schema version: 20100705154452
#
# Table name: beliefs
#
#  id         :integer         not null, primary key
#  ideal      :float
#  weight     :float
#  opinion_id :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Belief < ActiveRecord::Base
  belongs_to :user
  belongs_to :opinion
end
