require 'spec_helper'

describe ConceptsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/concepts" }.should route_to(:controller => "concepts", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/concepts/new" }.should route_to(:controller => "concepts", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/concepts/1" }.should route_to(:controller => "concepts", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/concepts/1/edit" }.should route_to(:controller => "concepts", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/concepts" }.should route_to(:controller => "concepts", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/concepts/1" }.should route_to(:controller => "concepts", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/concepts/1" }.should route_to(:controller => "concepts", :action => "destroy", :id => "1") 
    end
  end
end
