class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.float :value
      t.references :entity, :user, :opinion
      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end
