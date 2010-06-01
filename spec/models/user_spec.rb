require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {
      :name => "lise",
      :email => "lise@peepee.com",
      :hashed_pwd => "nothing",
      :enabled => true,
      :last_login => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
  
  it "should require a name" do
    no_name_user = User.new(@valid_attributes.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  
  it "should reject names that are too long" do
    no_name_user = User.new(@valid_attributes.merge(:name => "a"*65))
    no_name_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@doo.bar.com first.last@foo.org]
    addresses.each do |a|
      u = User.new(@valid_attributes.merge(:email => a))
      u.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[user@foo. THE_USER@bar,com first.last_at_foo.org]
    addresses.each do |a|
      u = User.new(@valid_attributes.merge(:email => a))
      u.should_not be_valid
    end
  end
  
  it "should reject users with duplicate emails of up case" do
    User.create!(@valid_attributes)
    u = User.new(@valid_attributes.merge(:email => @valid_attributes[:email].upcase))
    u.should_not be_valid
  end
  
end
