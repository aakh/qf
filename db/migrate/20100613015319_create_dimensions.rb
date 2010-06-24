class CreateDimensions < ActiveRecord::Migration
  def self.up
    create_table :dimensions do |t|
      t.string :name
      t.string :desc
      t.float :ideal, :default => nil
      t.float :weight, :default => nil
      t.boolean :bool, :default => false
      t.references :valuable, :polymorphic => true

      t.timestamps
    end
  end

  def self.down
    drop_table :dimensions
  end
end
