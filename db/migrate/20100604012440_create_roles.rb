class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name

      t.timestamps
    end
    
    Role.create!(:name => "Administrator")
    Role.create!(:name => "Staff")
  end

  def self.down
    drop_table :roles
  end
end
