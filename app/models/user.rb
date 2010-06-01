class User < ActiveRecord::Base
  attr_accessible :name, :email
  validates_presence_of :name, :email
  validates_length_of :name, :maximum => 64
  
  EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_format_of :email, :with => EmailRegex
  
  validates_uniqueness_of :email, :case_sensitive => false
end

