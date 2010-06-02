require 'spec_helper'

describe "/concepts/edit.html.erb" do
  include ConceptsHelper

  before(:each) do
    assigns[:concept] = @concept = stub_model(Concept,
      :new_record? => false,
      :name => "value for name",
      :desc => "value for desc"
    )
  end

  it "renders the edit concept form" do
    render

    response.should have_tag("form[action=#{concept_path(@concept)}][method=post]") do
      with_tag('input#concept_name[name=?]', "concept[name]")
      with_tag('input#concept_desc[name=?]', "concept[desc]")
    end
  end
end
