class CreateFactValues < ActiveRecord::Migration
  def self.up
    create_table :fact_values do |t|
      t.float :value
      t.references :fact, :entity
      t.timestamps
    end
    fc = Entity.find_by_name("Fish And Chips")
    gf = Entity.find_by_name("Golden Fries")
    mp = Entity.find_by_name("Montheith's Pilsner")
    
    p = (Dimension.find_by_name 'Price').valuable
    
    v = FactValue.create(:value => 19.5)
    v.fact = p
    v.entity = fc
    
    v.save!
    
  end

  def self.down
    drop_table :fact_values
  end
end
