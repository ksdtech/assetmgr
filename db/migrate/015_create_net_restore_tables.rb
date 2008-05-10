class CreateNetRestoreTables < ActiveRecord::Migration
  def self.up
    
    create_table "nr_admin_groups", :id => false, :force => true do |t|
      t.column "admin_group_id",   :integer,                                :null => false
      t.column "admin_group_name", :string,  :limit => 128, :default => "", :null => false
      t.column "passwd",           :string
    end

    add_index "nr_admin_groups", ["admin_group_name"], :name => "admin_group_name", :unique => true

    create_table "nr_gp_membership", :id => false, :force => true do |t|
      t.column "user_id",        :integer, :null => false
      t.column "admin_group_id", :integer, :null => false
    end

    create_table "nr_info", :id => false, :force => true do |t|
      t.column "version", :string, :limit => 10, :default => "", :null => false
    end

    create_table "nr_mach_spec_settings", :id => false, :force => true do |t|
      t.column "computerid",       :string, :limit => 17, :default => "", :null => false
      t.column "computer_name",    :string, :limit => 63
      t.column "rendezvous_name",  :string, :limit => 63
      t.column "ip_config_method", :string, :limit => 6
      t.column "ip_address",       :string, :limit => 15
      t.column "subnet_mask",      :string, :limit => 15
      t.column "router_address",   :string, :limit => 15
      t.column "dns_entries",      :string, :limit => 63
      t.column "ard_list_tag",     :string, :limit => 15
      t.column "location",         :string, :limit => 63
      t.column "user",             :string, :limit => 63
      t.column "asset_tag",        :string, :limit => 9
      t.column "serial_number",    :string, :limit => 31
    end

    add_index "nr_mach_spec_settings", ["computerid"], :name => "computerid", :unique => true

    create_table "nr_tools", :id => false, :force => true do |t|
      t.column "tool_id",        :integer,                                :null => false
      t.column "tool_name",      :string,  :limit => 128, :default => "", :null => false
      t.column "command",        :string,                 :default => "", :null => false
      t.column "admin_group_id", :integer,                :default => 1,  :null => false
    end

    create_table "nr_users", :id => false, :force => true do |t|
      t.column "user_id",  :integer,                                   :null => false
      t.column "username", :string,  :limit => 128, :default => "",    :null => false
      t.column "passwd",   :string
      t.column "is_admin", :boolean,                :default => false, :null => false
    end

    add_index "nr_users", ["username"], :name => "username", :unique => true

  end

  def self.down
  end
end
