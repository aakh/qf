require 'spec_helper'

describe "/concepts/show.html.erb" do
  include ConceptsHelper
  before(:each) do
    assigns[:concept] = @concept = stub_model(Concept,
      :name => "value for name",
      :desc => "value for desc"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ desc/)
  end
end
