require 'spec_helper'

describe ConceptsController do

  def mock_concept(stubs={})
    @mock_concept ||= mock_model(Concept, stubs)
  end

  describe "GET index" do
    it "assigns all concepts as @concepts" do
      Concept.stub(:find).with(:all).and_return([mock_concept])
      get :index
      assigns[:concepts].should == [mock_concept]
    end
  end

  describe "GET show" do
    it "assigns the requested concept as @concept" do
      Concept.stub(:find).with("37").and_return(mock_concept)
      get :show, :id => "37"
      assigns[:concept].should equal(mock_concept)
    end
  end

  describe "GET new" do
    it "assigns a new concept as @concept" do
      Concept.stub(:new).and_return(mock_concept)
      get :new
      assigns[:concept].should equal(mock_concept)
    end
  end

  describe "GET edit" do
    it "assigns the requested concept as @concept" do
      Concept.stub(:find).with("37").and_return(mock_concept)
      get :edit, :id => "37"
      assigns[:concept].should equal(mock_concept)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created concept as @concept" do
        Concept.stub(:new).with({'these' => 'params'}).and_return(mock_concept(:save => true))
        post :create, :concept => {:these => 'params'}
        assigns[:concept].should equal(mock_concept)
      end

      it "redirects to the created concept" do
        Concept.stub(:new).and_return(mock_concept(:save => true))
        post :create, :concept => {}
        response.should redirect_to(concept_url(mock_concept))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved concept as @concept" do
        Concept.stub(:new).with({'these' => 'params'}).and_return(mock_concept(:save => false))
        post :create, :concept => {:these => 'params'}
        assigns[:concept].should equal(mock_concept)
      end

      it "re-renders the 'new' template" do
        Concept.stub(:new).and_return(mock_concept(:save => false))
        post :create, :concept => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested concept" do
        Concept.should_receive(:find).with("37").and_return(mock_concept)
        mock_concept.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :concept => {:these => 'params'}
      end

      it "assigns the requested concept as @concept" do
        Concept.stub(:find).and_return(mock_concept(:update_attributes => true))
        put :update, :id => "1"
        assigns[:concept].should equal(mock_concept)
      end

      it "redirects to the concept" do
        Concept.stub(:find).and_return(mock_concept(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(concept_url(mock_concept))
      end
    end

    describe "with invalid params" do
      it "updates the requested concept" do
        Concept.should_receive(:find).with("37").and_return(mock_concept)
        mock_concept.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :concept => {:these => 'params'}
      end

      it "assigns the concept as @concept" do
        Concept.stub(:find).and_return(mock_concept(:update_attributes => false))
        put :update, :id => "1"
        assigns[:concept].should equal(mock_concept)
      end

      it "re-renders the 'edit' template" do
        Concept.stub(:find).and_return(mock_concept(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested concept" do
      Concept.should_receive(:find).with("37").and_return(mock_concept)
      mock_concept.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the concepts list" do
      Concept.stub(:find).and_return(mock_concept(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(concepts_url)
    end
  end

end
