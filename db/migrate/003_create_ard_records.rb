class CreateArdRecords < ActiveRecord::Migration
  def self.up
    create_table :ard_records, :id => false, :force => true do |t|
      t.column :mac_address, :string, :limit => 17 # id field
      t.column :ip_address, :string, :limit => 15
      t.column :computer_name, :string
      t.column :hostname, :string
    end
    add_index :ard_records, :mac_address
    add_index :ard_records, :ip_address
  end

  def self.down
    drop_table :ard_records
  end
end
