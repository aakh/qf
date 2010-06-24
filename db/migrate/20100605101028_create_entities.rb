class CreateEntities < ActiveRecord::Migration

  def self.add_item( concept, name)
    concept.entities << Entity.create( :name => name, :price => 0)
  end
  
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
    
    add_item(mains, "Fish And Chips")
    add_item(mains, "Steak And Chips")
    add_item(starters, "Golden Fries")
    add_item(starters, "Spicy Wedges")
    add_item(beer, "Montheith's Pilsner")
    add_item(beer, "Montheith's Original")
    add_item(beer, "Heineken" )
    add_item(beer, "Tiger" )
    add_item(beer, "Murphy's" )
    add_item(beer, "Tui" )
    
    mains.save!
    starters.save!
    beer.save!
    
  end

  def self.down
    drop_table :entities
  end
end
