class AddRolesUsersJoinTable < ActiveRecord::Migration
  def self.up
    create_table :roles_users, :id => false do |t|
      t.references :role, :user
    end
    
    ali = User.create(:email => "ali@aliak.net", :password => "admin", :password_confirmation => "admin",
                    :first_name => "Ali", :last_name => "Akhtarzada", :birthday => "8 June 1982",
                    :country => "Bahrain")

    r1 = Role.find_by_name("Administrator")
    r2 = Role.find_by_name("Manager")
    r3 = Role.find_by_name("Staff")
    
    ali.roles << r1 << r2 << r3 
    
    ali.save!
  end

  def self.down
    drop_table :roles_users
  end
end
