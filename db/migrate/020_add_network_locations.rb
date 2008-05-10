class AddNetworkLocations < ActiveRecord::Migration
  def self.up
    add_column :assets, :network_location, :string
    add_column :assets, :network_port, :string
  end

  def self.down
    drop_column :assets, :network_location
    drop_column :assets, :network_port
  end
end
