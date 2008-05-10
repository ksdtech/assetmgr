class AddPrinterColumns < ActiveRecord::Migration
  def self.up
    add_column :assets, :ppd_product, :string
    add_column :assets, :cups_http, :boolean, :null => false, :default => 0
    add_column :assets, :cups_ipp, :boolean, :null => false, :default => 0
    add_column :assets, :cups_lpr, :boolean, :null => false, :default => 0
  end

  def self.down
    drop_column :assets, :ppd_product
    drop_column :assets, :cups_http
    drop_column :assets, :cups_ipp
    drop_column :assets, :cups_lpr
  end
end
