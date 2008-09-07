class AddSnmpSupport < ActiveRecord::Migration
  def self.up
    add_column :assets, :snmp_printmib, :boolean
  end

  def self.down
  end
end
