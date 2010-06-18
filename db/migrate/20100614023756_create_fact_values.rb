class CreateFactValues < ActiveRecord::Migration
  def self.set_price(entity, price)
    p = Fact.find_by_name('Price')
    v = FactValue.create(:value => price)
    v.fact = p
    v.entity = entity
    v.save!
  end
  
  def self.up
    create_table :fact_values do |t|
      t.float :value
      t.references :fact, :entity
      t.timestamps
    end
    
    set_price(Entity.find_by_name("Fish And Chips"), 19.5)
    set_price(Entity.find_by_name("Steak And Chips"), 23)
    set_price(Entity.find_by_name("Golden Fries"), 7)
    set_price(Entity.find_by_name("Spicy Wedges"), 8.5)
    set_price(Entity.find_by_name("Montheith's Pilsner"), 8)
    set_price(Entity.find_by_name("Montheith's Original"), 8)
    set_price(Entity.find_by_name("Heineken"), 8.5)
  end

  def self.down
    drop_table :fact_values
  end
end
