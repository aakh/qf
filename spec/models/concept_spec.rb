# == Schema Information
# Schema version: 20100623234744
#
# Table name: concepts
#
#  id         :integer         not null, primary key
#  name       :string(255)     not null
#  desc       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Concept do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :desc => "value for desc"
    }
  end

  it "should create a new instance given valid attributes" do
    Concept.create!(@valid_attributes)
  end
end
