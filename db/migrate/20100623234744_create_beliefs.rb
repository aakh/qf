class CreateBeliefs < ActiveRecord::Migration
  def self.up
    create_table :beliefs do |t|
      t.float :ideal
      t.integer :position
      t.references :dimension, :user
      t.timestamps
    end
  end

  def self.down
    drop_table :beliefs
  end
end
