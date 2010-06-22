class CreateOpinions < ActiveRecord::Migration
  def self.up
    create_table :opinions do |t|
      t.float :ideal, :default => nil
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
