class CreateArdRecords < ActiveRecord::Migration
  def self.up
    return
    
    # ARD postgresql database already exists, this is just for documentation!
    
    create_table :propertynamemap, :id => false do |t|
      t.string  :objectname, :limit => 128, :null => false
      t.string  :propertyname, :limit => 128, :null => false
      t.integer :propertymapid
    end
    
    create_table :systeminformation, :id => false do |t|
      t.string  :computerid, :limit => 17, :null => false
      t.string  :objectname, :limit => 128, :null => false
      t.string  :propertyname, :limit => 128, :null => false
      t.integer :itemseq
      t.string  :value, :limit => 512
      t.datetime :lastupdated
    end
    
    create_table :applicationname, :id => false do |t|
      t.string  :computerid, :limit => 17, :null => false
      t.string  :appname, :limit => 512
      t.string  :appurl, :limit => 512
      t.integer :itemseq
      t.integer :lastupdated
    end
    
    create_table :applicationusage, :id => false do |t|
      t.string  :computerid, :limit => 17, :null => false
      t.string  :frontmost, :limit => 512
      t.string  :launchtime, :limit => 512
      t.string  :runlength, :limit => 512
      t.integer :itemseq
      t.integer :lastupdated
      t.string  :username, :limit => 512
      t.integer :runstate
    end

    create_table :userusage, :id => false do |t|
      t.string  :computerid, :limit => 17, :null => false
      t.integer :lastupdated
      t.string  :username, :limit => 512
      t.string  :logintype, :limit => 512
      t.string  :intime, :limit => 512
      t.string  :outtime, :limit => 512
      t.string  :host, :limit => 512
    end
  end

  def self.down
  end
end
