class CreateOpinions < ActiveRecord::Migration
  def self.up
    create_table :opinions do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :opinions
  end
end
