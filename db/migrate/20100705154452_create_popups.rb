class CreatePopups < ActiveRecord::Migration
  def self.up
    create_table :popups do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :popups
  end
end
