class AddPrinterColumns < ActiveRecord::Migration
  def self.up
    add_column :assets, :ppd_product, :string
    add_column :assets, :cups_http, :boolean, :null => false, :default => 0
    add_column :assets, :cups_ipp, :boolean, :null => false, :default => 0
    add_column :assets, :cups_lpr, :boolean, :null => false, :default => 0
  end

  def self.down
    remove_column :assets, :ppd_product
    remove_column :assets, :cups_http
    remove_column :assets, :cups_ipp
    remove_column :assets, :cups_lpr
  end
end
