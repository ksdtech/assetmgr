class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites, :id => false, :force => true do |t|
      t.integer :id
      t.string  :name
      t.timestamps
    end
    
    add_index :sites, :id, :unique => true
    
    [ [ 'District', 102 ], [ 'Bacich', 103 ], [ 'Kent', 104 ] ].each do |rec|
      s = Site.new(:name => rec[0])
      s.id = rec[1]
      s.save
    end
  end

  def self.down
    drop_table :sites
  end
end
