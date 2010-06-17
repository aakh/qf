# == Schema Information
# Schema version: 20100614023756
#
# Table name: dimensions
#
#  id            :integer         not null, primary key
#  name          :string(255)
#  desc          :string(255)
#  ideal         :float           default(0.0)
#  weight        :float           default(0.0)
#  valuable_id   :integer
#  valuable_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Dimension < ActiveRecord::Base
  belongs_to :valuable, :polymorphic => true
  has_and_belongs_to_many :concepts
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :valuable_type, :case_sensitive => false
   
  before_update :capitalize
  before_save :capitalize
  
  def capitalize
    #arr = name.split(/ /)
    #arr.each {|w| w.capitalize!}
    @attributes['name'].capitalize!# = arr.join ' '
    if @attributes['valuable_type'] == "Fact"
      @attributes['name'] = "+" + @attributes['name']
    end
  end
end
