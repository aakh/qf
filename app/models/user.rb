# == Schema Information
# Schema version: 20100605101028
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  email              :string(255)
#  crypted_password   :string(255)
#  password_salt      :string(255)
#  persistence_token  :string(255)
#  login_count        :integer         default(0), not null
#  failed_login_count :integer         default(0), not null
#  last_request_at    :datetime
#  current_login_at   :datetime
#  last_login_at      :datetime
#  current_login_ip   :string(255)
#  last_login_ip      :string(255)
#  first_name         :string(255)
#  last_name          :string(255)
#  country            :string(255)
#  birthday           :date
#  created_at         :datetime
#  updated_at         :datetime
#

class User < ActiveRecord::Base
  acts_as_authentic
  has_and_belongs_to_many :roles
  attr_accessor :role_ids
  validates_presence_of :password, :password_confirmation, :on => :create
  validates_presence_of :email
  
  def has_role?(rolename)
    self.roles.find_by_name(rolename) ? true : false
  end
end
