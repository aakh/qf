class AddCreatedByAndEditedByToDimensions < ActiveRecord::Migration
  def self.up
    add_column :dimensions, :created_by, :integer
    add_column :dimensions, :edited_by, :integer
    
    Dimension.reset_column_information
  end

  def self.down
    remove_column :dimensions, :created_by
    remove_column :dimensions, :edited_by
  end
end
