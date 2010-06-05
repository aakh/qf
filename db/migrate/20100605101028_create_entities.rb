class CreateEntities < ActiveRecord::Migration
  def self.up
    create_table :entities do |t|
      t.string :name
      t.text :desc
      t.references :concept
      
      t.timestamps
    end
  end

  def self.down
    drop_table :entities
  end
end
