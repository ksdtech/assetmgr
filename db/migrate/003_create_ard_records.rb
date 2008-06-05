class CreateArdRecords < ActiveRecord::Migration
  def self.up
    # database already exists, this is just for documentation!
    return
    
    create_table :propertynamemap, :id => false do |t|
      t.string  :objectname, :length => 128, :null => false
      t.string  :propertyname, :length => 128, :null => false
      t.integer :propertymapid
    end
    
    create_table :systeminformation, :id => false do |t|
      t.string  :computerid, :length => 17, :null => false
      t.string  :objectname, :length => 128, :null => false
      t.string  :propertyname, :length => 128, :null => false
      t.integer :itemseq
      t.string  :value, :length => 512
      t.datetime :lastupdated
    end
    
    create_table :applicationname, :id => false do |t|
      t.string  :computerid, :length => 17, :null => false
      t.string  :appname, :length => 512
      t.string  :appurl, :length => 512
      t.integer :itemseq
      t.integer :lastupdated
    end
    
    create_table :applicationusage, :id => false do |t|
      t.string  :computerid, :length => 17, :null => false
      t.string  :frontmost, :length => 512
      t.string  :launchtime, :length => 512
      t.string  :runlength, :length => 512
      t.integer :itemseq
      t.integer :lastupdated
      t.string  :username, :length => 512
      t.integer :runstate
    end

    create_table :userusage, :id => false do |t|
      t.string  :computerid, :length => 17, :null => false
      t.integer :lastupdated
      t.string  :username, :length => 512
      t.string  :logintype, :length => 512
      t.string  :intime, :length => 512
      t.string  :outtime, :length => 512
      t.string  :host, :length => 512
    end
  end

  def self.down
  end
end
