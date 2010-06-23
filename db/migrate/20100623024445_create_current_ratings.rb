class CreateCurrentRatings < ActiveRecord::Migration
  def self.up
    create_table :current_ratings do |t|
      t.float :total_rating, :default => 0
      t.integer :num_ratings, :default => 0
      t.references :entity, :opinion
      t.timestamps
    end
  end

  def self.down
    drop_table :current_ratings
  end
end
