class CreateAssetRecords < ActiveRecord::Migration
  def self.up
    create_table :asset_records, :id => false, :force => true do |t|
      t.column :barcode, :string, :limit => 9, :default => "", :null => false
      t.column :age, :decimal, :precision => 4, :scale => 1, :null => false
      t.column :category, :string, :limit => 31, :default => "", :null => false
      t.column :acqdate, :date, :null => false
      t.column :item, :string, :limit => 31, :default => "", :null => false
      t.column :make, :string, :limit => 31, :default => "", :null => false
      t.column :model, :string, :limit => 31, :default => "", :null => false
      t.column :acqcost, :decimal, :precision => 10, :scale => 2, :null => false
      t.column :ponumber, :string, :limit => 6, :default => "", :null => false
      t.column :room_no, :string, :limit => 31, :default => "", :null => false
      t.column :serialnum, :string, :limit => 31, :default => "", :null => false
      t.column :sitename, :string, :limit => 31, :default => "", :null => false
      t.column :struc, :string, :limit => 31, :default => "", :null => false
      t.column :subcat, :string, :limit => 31, :default => "", :null => false
      t.column :uselife, :integer, :limit => 10, :default => 0, :null => false
      t.column :vendor, :string, :limit => 31, :default => "", :null => false
    end
    add_index :asset_records, :barcode, :unique => true
    add_index :asset_records, :serialnum
  end

  def self.down
    drop_table :asset_records
  end
end
