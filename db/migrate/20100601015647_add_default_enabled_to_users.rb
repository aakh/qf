class AddDefaultEnabledToUsers < ActiveRecord::Migration
  def self.up
    change_column :users, :enabled, :boolean, :default => true
    User.all.each do |u| 
      u.update_attribute(:enabled, true)
    end
  end

  def self.down
    change_column :users, :enabled, :boolean, :default => true
  end
end
