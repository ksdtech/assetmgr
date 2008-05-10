class CreateSoftwareLicenses < ActiveRecord::Migration
  def self.up
    create_table :software_licenses, :force => true do |t|
      t.column :application,  :string
      t.column :publisher,  :string
      t.column :version,  :string
      t.column :mfr_sku,  :string
      t.column :vendor_contact_info,  :string
      t.column :license_type, :string
      t.column :os, :string
      t.column :number_installed,  :integer
      t.column :number_of_licenses, :integer
      t.column :use,  :string
      t.column :location, :string
      t.column :name_on_license,  :string
      t.column :purchase_date,  :date
      t.column :license_expires,  :date
      t.column :serial_number,  :string
      t.column :install_key,  :string
      t.column :notes,  :string
      t.column :creator,  :string
      t.column :gid,  :integer
    end
  end

  def self.down
    drop_table :software_licenses
  end
end
