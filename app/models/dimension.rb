# == Schema Information
# Schema version: 20100613020951
#
# Table name: dimensions
#
#  id            :integer         not null, primary key
#  name          :string(255)
#  desc          :string(255)
#  ideal         :float
#  weight        :float
#  min           :float
#  max           :float
#  valuable_id   :integer
#  valuable_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Dimension < ActiveRecord::Base
  belongs_to :valuable, :polymorphic => true
  has_and_belongs_to_many :concepts
  validates_presence_of :name
end
