class CreateOpinions < ActiveRecord::Migration
  def self.up
    create_table :opinions do |t|
      t.string :low_text, :default => "bad"
      t.string :high_text, :default => "excellent"
      t.float :total_ideal, :default => 0
      t.integer :num_ideals, :default => 0
      t.float :total_weight, :default => 0
      t.integer :num_weights, :default => 0
      t.timestamps
    end
    
    o = Opinion.create
    o.dimension = Dimension.new :name => "Quality"
    o.save!
  end

  def self.down
    drop_table :opinions
  end
end
