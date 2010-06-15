# == Schema Information
# Schema version: 20100614023756
#
# Table name: entities
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  desc               :text
#  concept_id         :integer
#  created_at         :datetime
#  updated_at         :datetime
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#

class Entity < ActiveRecord::Base
  belongs_to :concept
  
  has_many :fact_values
  has_many :facts, :through => :fact_values
  
  validates_presence_of :name, :concept
  has_attached_file :photo, #:styles => { :thumb => "100x100>" },
                    :url  => "/images/entities/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/images/entities/:id/:style/:basename.:extension"
  
  # validates_attachment_presence :photo
  #validates_attachment_size :photo, :less_than => 5.megabytes
  #validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  validates_uniqueness_of :name, :scope => :concept_id, :case_sensitive => false
  
  before_update :capitalize
  
  def capitalize
    arr = name.split(/ /)
    arr.each {|w| w.capitalize!}
    @attributes['name'] = arr.join ' '
  end
  
  accepts_nested_attributes_for :fact_values
  attr_accessor :price
  
end
