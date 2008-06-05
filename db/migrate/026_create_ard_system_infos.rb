class CreateArdSystemInfos < ActiveRecord::Migration
  def self.up
    create_table :ard_records, :id => false, :force => true do |t|
      ArdSystemInfo::SYSTEM_INFO_PROPERTIES.each do |propname, colname, coltype, options|
        t.column colname, coltype, options
      end
      t.timestamps
    end
  end

  def self.down
    drop_table :ard_records
  end
end
