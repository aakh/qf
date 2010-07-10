class AddEnabledToDimensions < ActiveRecord::Migration
  def self.up
    add_column :dimensions, :enabled, :boolean, :default => true
    
    Dimension.all.each do |dim|
      dim.enabled = true
    end
    
    Dimension.reset_column_information
  end

  def self.down
    remove_column :dimensions, :enabled
  end
end
