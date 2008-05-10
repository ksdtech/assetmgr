class CreateNrConfigurations < ActiveRecord::Migration
  def self.up
    
    create_table :nr_configurations, :force => true do |t|
      t.column :name,           :string,  :limit => 128, :default => "", :null => false
      t.column :description,    :text
      t.column :protocol,       :string,  :limit => 6,   :default => "", :null => false
      t.column :host_or_volume, :string,  :limit => 128, :default => "", :null => false
      t.column :sharepoint,     :string,  :limit => 128
      t.column :path,           :string,  :limit => 128, :default => "", :null => false
      t.column :username,       :string,  :limit => 128
      t.column :password,       :string,  :limit => 128
      t.column :created_at,     :datetime
      t.column :updated_at,     :datetime
    end

    add_index "nr_configurations", ["name"], :name => "name", :unique => true
    
    NrConfiguration.create(:name => '2007-07-intel-kent',
      :description => 'New image for 2007 intel lab, library and desktop machines',
      :protocol => 'afp', :host_or_volume => '10.4.51.76',
      :sharepoint => 'Images', :username => 'imaging', :password => '',
      :path => '2007-07-intel-kent.dmg')
  end

  def self.down
    drop_table :nr_configurations
  end
end
