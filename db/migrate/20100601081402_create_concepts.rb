class CreateConcepts < ActiveRecord::Migration
  def self.up
    create_table :concepts do |t|
      t.string :name, :null => false
      t.string :desc

      t.timestamps
    end
    
    Concept.create!(:name => "Mains", :desc => "")
    Concept.create!(:name => "Starters", :desc => "")
    Concept.create!(:name => "Beer", :desc => "")
    
  end

  def self.down
    drop_table :concepts
  end
end
