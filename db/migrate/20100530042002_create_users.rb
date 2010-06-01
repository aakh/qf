class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :hashed_pwd
      t.boolean :enabled
      t.datetime :last_login

      t.timestamps
    end
    
  end

  def self.down
    drop_table :users
  end
end
