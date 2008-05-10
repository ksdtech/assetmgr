class CreateEthers < ActiveRecord::Migration
  def self.up
    create_table :ethers, :force => true do |t|
      t.column :asset_id, :integer
      t.column :interface_id, :string, :limit => 8
      t.column :mac_address, :string, :limit => 17, :default => "", :null => false
      t.column :media_type, :string, :limit => 10 # 'cat5', 'fiber', 'wireless'
    end
    add_index :ethers, :mac_address
  end

  def self.down
    drop_table :ethers
  end
end
