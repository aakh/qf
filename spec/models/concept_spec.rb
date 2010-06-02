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
