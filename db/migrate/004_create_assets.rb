class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets, :force => true do |t|
      t.column :type, :string
      t.column :item_class, :string, :limit => 20
      t.column :status, :string, :limit => 15, :null => false, :default => 'unknown'
      t.column :disposition_date, :date
      t.column :disposition_notes, :string
      t.column :name, :string, :limit => 31
      t.column :name_prefix, :string, :limit => 25
      t.column :name_index, :integer
      t.column :manufacturer, :string
      t.column :description, :string
      t.column :notes, :text
      t.column :purchased, :date
      t.column :barcode, :string, :limit => 9
      t.column :serial_number, :string, :limit => 31
      t.column :mac_address, :string, :limit => 17
      t.column :location, :string, :limit => 63
      t.column :location_site, :string, :limit => 9
      t.column :location_prefix, :string, :limit => 31
      t.column :location_index, :integer
      t.column :location_suffix, :string, :limit => 15
      t.column :user, :string, :limit => 63
      t.column :unix_hostname, :string, :limit => 63
      t.column :rom_version, :string, :limit => 63
      t.column :ip_config_method, :string, :limit => 6
      t.column :ip_address, :string, :limit => 15
      t.column :subnet_mask, :string, :limit => 15
      t.column :router_address, :string, :limit => 15
      t.column :dns_entries, :string, :limit => 63
      t.column :base_t_10_ports, :integer
      t.column :base_t_100_ports, :integer
      t.column :base_t_1000_ports, :integer
      t.column :sx_1000_ports, :integer
      t.column :usb_ports, :integer
      t.column :firewire_ports, :integer
      t.column :supports_ethertalk, :boolean 
      t.column :supports_bonjour, :boolean
      t.column :connection_type, :string
      t.column :battery_serial_number, :string
      t.column :surplus_item_number, :string, :limit => 15
      t.column :updated_at, :datetime
      # computer info
      t.column :mfr_machine_model, :string, :limit => 63
      t.column :cpu_type, :string, :limit => 63
      t.column :cpu_speed_mhz, :float
      t.column :processor_count, :integer
      t.column :memory_mb, :float
      t.column :total_disk_space_gb, :float
      t.column :optical_drive_type, :string, :limit => 63
      t.column :operating_system, :string, :limit => 63
      t.column :ard_data_last_collected_at, :datetime
      t.column :default_printer_name, :string, :limit => 63
      # netrestore information
      t.column :machine_group_id,    :integer
      # printer info
      t.column :print_engine_type, :string
      t.column :color, :boolean, :null => false, :default => 0
      t.column :duplex, :boolean, :null => false, :default => 0
      t.column :envelopes, :boolean, :null => false, :default => 0
      t.column :collator, :boolean, :null => false, :default => 0
      t.column :scanner, :boolean, :null => false, :default => 0
      t.column :fax, :boolean, :null => false, :default => 0
      t.column :queue_host, :string
      t.column :queue_name, :string
      t.column :usb_host_asset_id, :integer
      # network switch/router/base station info
      t.column :net_device_type, :string # 'switch', 'router', 'wireless-base', 'wireless-sub'
      t.column :operating_mode, :string # 'bridge', 'router'
      t.column :ssid, :string
      t.column :bound_to_asset_id, :integer
      t.column :channel_config_method, :string, :limit => 6
      t.column :channel, :integer
      t.column :wireless_a, :boolean
      t.column :wireless_b, :boolean
      t.column :wireless_g, :boolean
      t.column :wireless_n, :boolean
    end
    add_index :assets, :barcode
    add_index :assets, :serial_number
    add_index :assets, :mac_address
    add_index :assets, :ip_address
  end

  def self.down
    drop_table :assets
  end
end
