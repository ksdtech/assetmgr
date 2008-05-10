class CreateArpRecords < ActiveRecord::Migration
  def self.up
    create_table :arp_records, :force => true do |t|
      t.column :mac_address, :string, :limit => 17, :null => false
      t.column :ip_address, :string, :limit => 15, :null => false
      t.column :collected_at, :datetime
    end
    add_index :arp_records, :mac_address
    add_index :arp_records, :ip_address
  end

  def self.down
    drop_table :arp_records
  end
end
