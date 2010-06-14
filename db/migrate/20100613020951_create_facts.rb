class CreateFacts < ActiveRecord::Migration
  def self.up
    create_table :facts do |t|
      t.timestamps
    end
    
    f = Fact.create
    f.dimension = Dimension.new :name => "Price"
    f.save!
  end

  def self.down
    drop_table :facts
  end
end
