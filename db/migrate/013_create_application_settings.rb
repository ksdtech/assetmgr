class CreateApplicationSettings < ActiveRecord::Migration
  def self.up
    create_table :application_settings, :force => true do |t|
      t.column :inventory_id, :integer
    end
    settings = ApplicationSetting.create
    inv = Inventory.create(:name => 'Feb 2007 Inventory', 
      :purpose => 'Inventory',
      :start_date => '2007-02-19')
    settings.current_inventory = inv
    settings.save!
  end

  def self.down
    drop_table :application_settings
  end
end
