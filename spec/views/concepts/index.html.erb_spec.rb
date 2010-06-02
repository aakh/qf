require 'spec_helper'

describe "/concepts/index.html.erb" do
  include ConceptsHelper

  before(:each) do
    assigns[:concepts] = [
      stub_model(Concept,
        :name => "value for name",
        :desc => "value for desc"
      ),
      stub_model(Concept,
        :name => "value for name",
        :desc => "value for desc"
      )
    ]
  end

  it "renders a list of concepts" do
    render
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", "value for desc".to_s, 2)
  end
end
