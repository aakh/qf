# == Schema Information
# Schema version: 20100605101028
#
# Table name: entities
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  desc       :text
#  concept_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Entity < ActiveRecord::Base
  belongs_to :concept
  validates_presence_of :name, :concept
  has_attached_file :photo,
                    :url  => "/images/entities/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/images/entities/:id/:style/:basename.:extension"
  
  # validates_attachment_presence :photo
  #validates_attachment_size :photo, :less_than => 5.megabytes
  #validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  
end
