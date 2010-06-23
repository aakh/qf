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
  
  has_many :fact_values, :dependent => :destroy
  has_many :facts, :through => :fact_values
  
  validates_presence_of :name, :concept, :price
  has_attached_file :photo, #:styles => { :thumb => "100x100>" },
                    :url  => "/images/entities/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/images/entities/:id/:style/:basename.:extension"
  
  # validates_attachment_presence :photo
  #validates_attachment_size :photo, :less_than => 5.megabytes
  #validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  validates_uniqueness_of :name, :scope => :concept_id, :case_sensitive => false
  
  before_validation :fix_name
  
  def fix_name
    @attributes['name'] = @attributes['name'].titleize
  end
  
  attr_accessor :price
  
  has_many :ratings, :dependent => :destroy
  has_many :users, :through => :ratings
  has_many :opinions, :through => :ratings
  
  has_many :current_ratings, :dependent => :destroy
  has_many :opinions, :through => :current_ratings
  
end
