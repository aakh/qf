# == Schema Information
# Schema version: 20100705154452
#
# Table name: comments
#
#  id               :integer         not null, primary key
#  title            :string(50)      default("")
#  body             :text            not null
#  commentable_id   :integer
#  commentable_type :string(255)
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  default_scope :order => 'created_at ASC'
  belongs_to :user
  validates_presence_of :body
  validates_length_of :title, :maximum => 50
end
