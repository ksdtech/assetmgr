class AddArchitecture < ActiveRecord::Migration
  def self.up
    add_column :assets, :architecture, :string, :limit => 10
    add_column :nr_machine_groups, :architecture, :string, :limit => 10
  end

  def self.down
    remove_column :nr_machine_groups, :architecture, :string, :limit => 10
    remove_column :assets, :architecture, :string, :limit => 10
  end
end
