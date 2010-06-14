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
    beer = Concept.find_by_name 'Tap Beer'
    
    mains.entities << 
      Entity.create( :name => "Fish And Chips") <<
      Entity.create( :name => "Steak And Chips")
    starters.entities << 
      Entity.create( :name => "Golden Fries") <<    
      Entity.create( :name => "Spicy Wedges")
    beer.entities << 
      Entity.create( :name => "Montheith's Pilsner") <<
      Entity.create( :name => "Montheith's Original") <<
      Entity.create( :name => "Heineken" )
    
    mains.save!
    starters.save!
    beer.save!
    
  end

  def self.down
    drop_table :entities
  end
end
