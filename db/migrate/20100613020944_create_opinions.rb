class CreateOpinions < ActiveRecord::Migration
  def self.up
    create_table :opinions do |t|
      t.float :ideal, :default => nil
      t.string :low_text, :default => "low"
      t.string :high_text, :default => "high"
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
