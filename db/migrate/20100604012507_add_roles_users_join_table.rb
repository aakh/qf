class AddRolesUsersJoinTable < ActiveRecord::Migration
  def self.up
    create_table :roles_users, :id => false do |t|
      t.references :role, :user
    end
    
    u = User.create(:email => "ali@aliak.net", :password => "admin", :password_confirmation => "admin")
    r1 = Role.find_by_name("Administrator")
    r2 = Role.find_by_name("Manager")
    r3 = Role.find_by_name("Staff")
    
    u.roles << r1 << r2 << r3 
    u.save!
  end

  def self.down
    drop_table :roles_users
  end
end
