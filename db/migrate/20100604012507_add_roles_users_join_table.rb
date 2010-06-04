class AddRolesUsersJoinTable < ActiveRecord::Migration
  def self.up
    create_table :roles_users, :id => false do |t|
      t.references :role, :user
    end
    
    u = User.create(:email => "ali@aliak.net", :password => "admin", :password_confirmation => "admin")
    r = Role.find_by_name("Administrator")
    
    u.roles << r
    u.save!
  end

  def self.down
    drop_table :roles_users
  end
end
