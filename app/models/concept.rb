# == Schema Information
# Schema version: 20100605220136
#
# Table name: concepts
#
#  id         :integer         not null, primary key
#  name       :string(255)     not null
#  desc       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Concept < ActiveRecord::Base
  validates_presence_of :name
  validates_length_of :name, :within => 2..255
  validates_length_of :desc, :maximum => 1000
  has_many :entities, :dependent => :destroy
  validates_uniqueness_of :name, :case_sensitive => false
end
