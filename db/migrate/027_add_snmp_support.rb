class AddSnmpSupport < ActiveRecord::Migration
  def self.up
    add_column :assets, :snmp_printer_mib, :boolean
  end

  def self.down
    remove_column :assets, :snmp_printer_mib
  end
end
