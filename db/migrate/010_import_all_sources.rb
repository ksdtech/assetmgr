class ImportAllSources < ActiveRecord::Migration
  def self.up
    AssetRecord.import_csv
    Printer.import_csv
    WirelessDevice.import_csv
    Computer.import_ard_db
    Computer.import_ard_lists
    Computer.import_laptop_csv
  end

  def self.down
    Asset.remove_all_data
  end
end
