class CreateNrParameters < ActiveRecord::Migration
  def self.up
    create_table :nr_parameters, :force => true do |t|
      t.column :name,                :string
      t.column :description,         :text
      t.column :target_disk_name,    :string,  :limit => 30, :default => "Macintosh HD"
      t.column :erase_target,        :boolean,               :default => true,      :null => false
      t.column :verify_restore,      :boolean,               :default => false,     :null => false
      t.column :set_target_as_boot_disk, :boolean,           :default => true,      :null => false
      t.column :should_restart,      :boolean,               :default => true,      :null => false
      t.column :fully_automate,      :boolean,               :default => false,     :null => false
      t.column :disable_own,         :boolean,               :default => false,     :null => false
      t.column :rebuild_desktop,     :boolean,               :default => true,      :null => false
      t.column :buffers,             :string,  :limit => 11, :default => "1,8,8,2", :null => false
    end
    
    NrParameter.create(:name => 'Default NetRestore Settings', :description => 'Install as boot disk on Macintosh HD and restart')
  end

  def self.down
    drop_table :nr_parameters
  end
end
