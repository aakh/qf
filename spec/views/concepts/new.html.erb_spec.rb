require 'spec_helper'

describe "/concepts/new.html.erb" do
  include ConceptsHelper

  before(:each) do
    assigns[:concept] = stub_model(Concept,
      :new_record? => true,
      :name => "value for name",
      :desc => "value for desc"
    )
  end

  it "renders new concept form" do
    render

    response.should have_tag("form[action=?][method=post]", concepts_path) do
      with_tag("input#concept_name[name=?]", "concept[name]")
      with_tag("input#concept_desc[name=?]", "concept[desc]")
    end
  end
end
