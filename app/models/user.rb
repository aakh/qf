class User < ActiveRecord::Base
  acts_as_authentic
  #attr_accessor :password, :password_confirmation
end
