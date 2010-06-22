class AddRolesUsersJoinTable < ActiveRecord::Migration
  def self.up
    create_table :roles_users, :id => false do |t|
      t.references :role, :user
    end
    
    ali = User.create(:email => "ali@aliak.net", :password => "admin", :password_confirmation => "admin",
                    :first_name => "Ali", :last_name => "Akhtarzada", :birthday => "8 June 1982",
                    :country => "Bahrain")
                    
    nick = User.create(:email => "nick@aliak.net", :password => "user", :password_confirmation => "user",
                    :first_name => "Nick", :last_name => "Enman", :birthday => "8 June 1952",
                    :country => "Zambia")
                    
    user = User.create(:email => "user@aliak.net", :password => "user", :password_confirmation => "user",
                    :first_name => "Some", :last_name => "User", :birthday => "4 May 1952",
                    :country => "France")
                    
    r1 = Role.find_by_name("Administrator")
    r2 = Role.find_by_name("Manager")
    r3 = Role.find_by_name("Staff")
    
    ali.roles << r1 << r2 << r3 
    nick.roles << r2 << r3
    
    ali.save!
    nick.save!
    user.save!
    
  end

  def self.down
    drop_table :roles_users
  end
end
