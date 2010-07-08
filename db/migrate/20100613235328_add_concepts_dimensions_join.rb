class AddConceptsDimensionsJoin < ActiveRecord::Migration

  
  def self.up
    create_table :concepts_dimensions, :id => false do |t|
      t.references :concept, :dimension
    end
    
  end

  def self.down
    drop_table :concepts_dimensions
  end
end
