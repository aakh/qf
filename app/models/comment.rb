class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  default_scope :order => 'created_at ASC'
  belongs_to :user
  validates_presence_of :body
  validates_length_of :title, :maximum => 50
end
