class CreateEntities < ActiveRecord::Migration
  def self.up
    create_table :entities do |t|
      t.string :name
      t.text :desc
      t.references :concept
      
      t.timestamps
    end
    
    mains = Concept.find_by_name 'Mains'
    starters = Concept.find_by_name 'Starters'
    beer = Concept.find_by_name 'Beer'
    
    mains.entities << Entity.create( :name => "Fish And Chips")
    starters.entities << Entity.create( :name => "Golden Fries")
    beer.entities << Entity.create( :name => "Montheith's Pilsner")
    
    mains.save!
    starters.save!
    beer.save!
    
  end

  def self.down
    drop_table :entities
  end
end
