class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :id => false, :force => true do |t|
      t.integer  :id
      t.integer  :site_id
      t.string   :first_name
      t.string   :last_name
      t.string   :telephone
      t.string   :email_address
      t.string   :login
      t.string   :password
      t.boolean  :administrator, :null => false, :default => false
      t.boolean  :accepts_assignments, :null => false, :default => false
      t.datetime :last_login_at
      t.datetime :last_access_at
      t.string   :last_access_from
      t.timestamps
    end
    
    add_index :users, :id, :unique => true
    add_index :users, :login, :unique => true
    add_index :users, :email_address, :unique => true
    
    # import users from a csv file
    User.import_users

    # set up at least one admin user
    ['admin_user1', 'admin_user2', 'admin_user3'].each do |login|
      u = User.find_by_login(login)
      u.update_attributes(:administrator => true, :accepts_assignments => true) if u
    end
  end

  def self.down
    drop_table :users
  end
end
