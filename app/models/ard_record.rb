
class ArdRecord < ActiveRecord::Base
  set_table_name :systeminformation
  establish_connection :ard
  
  # See http://www.cocoadev.com/index.pl?MacintoshModels
  MAC_MODELS = {
    "ADP2,1" => "Developer Transition Kit",
    'iMac' => 'iMac G3', # 266-333 MHz
    "iMac,1" => "iMac", 
    "iMac4,1" => "iMac (Core Duo)",
    'iMac4,2' => "iMac (Core Duo)",
    "iMac5,1" => "iMac (Core 2 Duo)", 
    'iMac5,2' => "iMac (Core 2 Duo)", 
    "iMac6,1" => "iMac (24-inch Core 2 Duo)",
    "M43ADP1,1"  => "Development Mac Pro",
    "MacBook1,1" => "MacBook (Core Duo)",
    "MacBook2,1" => "MacBook (Core 2 Duo)",
    "MacBook3,1" => "MacBook (Core 2 Duo)",
    "MacBook4,1" => "MacBook (Early 2008)",
    "MacBookAir1,1" => "MacBook Air",
    "MacBookPro1,1" => "MacBook Pro (15-inch Core Duo)", 
    "MacBookPro1,2" => "MacBook Pro (17-inch Core Duo)",
    "MacBookPro2,1" => "MacBook Pro (17-inch Core 2 Duo)",
    "MacBookPro2,2" => "MacBook Pro (15-inch Core 2 Duo)",
    "MacBookPro3,1" => "MacBook Pro (15-inch or 17-inch LED, Core 2 Duo)",
    "MacBookPro4,1" => "MacBook Pro (15-inch of 17-inch LED, Early 2008)",
    "Macmini1,1" => "Mac mini (Core Duo/Solo)",
    "Macmini2,1" => "Mac mini (Core 2 Duo)",
    "MacPro1,1" => "Mac Pro (Quad Xeon)",
    "MacPro2,1" => "Mac Pro (Octal Xeon)",
    "MacPro3,1" => "Mac Pro (Early 2008)",
    "PowerBook1,1" => "PowerBook G3", 
    "PowerBook2,1" => "iBook", 
    "PowerBook2,2" => "iBook (FireWire)", 
    "PowerBook3,1" => "PowerBook G3 (FireWire)", 
    "PowerBook3,2" => "PowerBook G4", 
    "PowerBook3,3" => "PowerBook G4 (Gigabit Ethernet)", 
    "PowerBook3,4" => "PowerBook G4 (DVI)", # 667-800 MHz
    "PowerBook3,5" => "PowerBook G4", # 867-1 GHz 
    "PowerBook4,1" => "iBook G3", 
    "PowerBook4,2" => "iBook G3", 
    "PowerBook4,3" => "iBook G3", # 700 MHz
    "PowerBook5,1" => "PowerBook G4 (17-inch)", 
    "PowerBook5,2" => "PowerBook G4 (15-inch FW800)", 
    "PowerBook5,3" => "PowerBook G4 (17-inch)", # 1.33 GHz
    "PowerBook5,4" => "PowerBook G4 (15-inch)", # 1.33-1.5 GHz
    "PowerBook5,5" => "PowerBook G4 (17-inch)", # 1.5 GHz 
    "PowerBook5,6" => "PowerBook G4 (15-inch)", # 1.5-1.67 GHz 
    "PowerBook5,7" => "PowerBook G4 (17-inch)", # 1.67 GHz
    "PowerBook5,8" => "PowerBook G4 (Double-Layer SD, 15-inch)", 
    "PowerBook5,9" => "PowerBook G4 (Double-Layer SD, 17-inch)", 
    "PowerBook6,1" => "PowerBook G4 (12-inch)", 
    "PowerBook6,2" => "PowerBook G4 (12-inch DVI)", 
    "PowerBook6,3" => "iBook G4", 
    "PowerBook6,4" => "PowerBook G4 (12-inch)", # 1.33 GHz
    "PowerBook6,5" => "iBook G4", # 1.2 GHz
    "PowerBook6,7" => "iBook G4", # 1.42-1.5 GHz
    "PowerBook6,8" => "PowerBook G4 (12-inch)", # 1.5 GHz
    "PowerMac1,1" => "Power Macintosh G3 (B&W)", 
    "PowerMac1,2" => "Power Macintosh G4 (PCI-Graphics)", 
    "PowerMac2,1" => "iMac G3 (Slot-Loading)", # 350-400 MHz
    "PowerMac2,2" => "iMac G3 (2000)", # 350-500 MHz
    "PowerMac3,1" => "Power Macintosh G4 (AGP-Graphics)", 
    "PowerMac3,2" => "Power Macintosh G4 (AGP-Graphics)", 
    "PowerMac3,3" => "Power Macintosh G4 (Gigabit Ethernet)", 
    "PowerMac3,4" => "Power Macintosh G4 (Digital Audio)", 
    "PowerMac3,5" => "Power Macintosh G4 (Quick Silver)", 
    "PowerMac3,6" => "Power Macintosh G4 (Mirrored Drive Doors)", 
    "PowerMac4,1" => "iMac G3 (2001)", # 500-600 MHz
    "PowerMac4,2" => "iMac G4 (Flat Panel)", # 700 MHz
    "PowerMac4,4" => "eMac G4", # 700-800 MHz
    "PowerMac4,5" => "iMac (17-inch Flat Panel)", 
    "PowerMac5,1" => "Power Macintosh G4 Cube", 
    "PowerMac6,1" => "iMac (USB 2.0)", 
    "PowerMac6,3" => "iMac G4 (20-inch Flat Panel)", # 1.25 GHz
    "PowerMac6,4" => "eMac G4 (USB 2.0)", # 1.0-1.25 GHz
    "PowerMac7,2" => "Power Macintosh G5", # 2.0 GHz
    "PowerMac7,3" => "Power Macintosh G5", 
    "PowerMac8,1" => "iMac G5", # 1.8 GHz
    "PowerMac8,2" => "iMac G5 (Ambient Light Sensor)", # 1.8-2.0 GHz
    "PowerMac9,1" => "Power Macintosh G5 (Late 2004)", 
    "PowerMac10,1" => "Mac mini", 
    "PowerMac10,2" => "Mac mini", 
    "PowerMac11,2" => "Power Macintosh G5 (PCIe)", # 2.0 
    "PowerMac12,1" => "iMac G5 (iSight)", 
    "RackMac1,1" => "Xserve G4", 
    "RackMac1,2" => "Xserve G4 (Slot-Loading)",
    "RackMac3,1" => "Xserve G5", # 2.3 GHz
    "Xserve1,1" => "Xserve (Dual-Core Xeon)",
  }

  ARD_FIELDS = [

  # sytem information
  { 'object' => 'Mac_SystemInfoElement',
    'maxcount' => 1,
    'is_system' => true,
    'fields' => [
  [ 'appletalk_name', 't', 'ComputerName' ], # bacich-b23
  [ 'mdns_hostname', 't', 'UnixHostName' ], # bacich-b23
  [ 'mac_address_primary', 't', 'PrimaryNetworkHardwareAddress' ], # 00:14:51:06:F3:76
  [ 'mac_address_en0', 't', 'En0Address' ], # 00:14:51:06:F3:76
  [ 'serial_number', 't', 'MachineSerialNumber' ], # 4H52602CS87
  [ 'machine_model', 't', 'MachineModel' ], # PowerBook6,5
  [ 'machine_class', 't', 'MachineClass' ], # PowerPC G4  (1.2)
  [ 'num_processors', 'i', 'ProcessorCount' ], # 1
  [ 'processor_type', 't', 'ProcessorType' ], # 275
  [ 'processor_speed', 'i', 'ProcessorSpeed' ], # 1200
  [ 'processor_speed_string', 't', 'ProcessorSpeedString' ], # 1.2 GHz
  [ 'bus_width', 'i', 'BusDataSize' ], # 32
  [ 'bus_speed', 'f', 'BusSpeed' ], # 133.12199401855469
  [ 'bus_speed_string', 't', 'BusSpeedString' ], # 133 MHz
  [ 'physical_memory_size', 'i', 'PhysicalMemorySize' ], # 524288
  [ 'monitor_type', 't', 'MainMonitorType' ], # LCD
  [ 'monitor_height', 'i', 'MainMonitorHeight' ], # 768
  [ 'monitor_width', 'i', 'MainMonitorWidth' ], # 1024
  [ 'monitor_depth', 'i', 'MainMonitorDepth' ], # 32
  [ 'rom_version', 't', 'BootROMVersion' ], # 4.8.7f1
  [ 'system_version', 't', 'SystemVersion' ], # 4162
  [ 'system_version_string', 't', 'SystemVersionString' ], # Mac OS X 10.4.2 (8C46)
  [ 'ard1_info', 't', 'ARDComputerInfo1' ], 
  [ 'ard2_info', 't', 'ARDComputerInfo2' ],
  [ 'ard3_info', 't', 'ARDComputerInfo3' ],
  [ 'ard4_info', 't', 'ARDComputerInfo4' ],
  ] },

  # for each hard disk, keyed on UnixMountPoint
  { 'object' => 'Mac_HardDriveElement',
    'maxcount' => 4,
    'is_system' => false,
    'fields' => [
  [ 'hd#_mount_point', 't', 'UnixMountPoint' ], # /dev/disk0s3
  [ 'hd#_model', 't', 'Model' ], # FUJITSU MHT2030AT
  [ 'hd#_total_size', 'i', 'TotalSize' ], # 29171400
  [ 'hd#_free_space', 'i', 'FreeSpace' ], # 21614400
  [ 'hd#_protocol', 't', 'Protocol' ], # ATA
  [ 'hd#_removable', 'b', 'RemovableMedia' ], # false
  [ 'hd#_boot_volume', 'b', 'IsBootVolume' ], # true
  ] },

  # for each RAM slot, keyed on SlotIdentifier
  { 'object' => 'Mac_RAMSlotElement',
    'maxcount' => 4,
    'is_system' => false,
    'fields' => [
  [ 'ram#_id', 't', 'SlotIdentifier' ], # DIMM0/BUILT-IN
  [ 'ram#_module_size', 't', 'MemoryModuleSize' ], # 256 MB
  ] },

  # for ethernet and airport ConfigurationType only, keyed on InterfaceName
  { 'object' => 'Mac_NetworkInterfaceElement',
    'maxcount' => 4,
    'is_system' => false,
    'fields' => [
  [ 'if#_name', 't',  'InterfaceName' ], # en1
  [ 'if#_primary', 'b', 'IsPrimary' ], # true
  [ 'if#_configuration_name', 't', 'ConfigurationName' ], # AirPort, Built-in Ethernet
  [ 'if#_configuration_type', 't', 'ConfigurationType' ], # AirPort, Ethernet
  [ 'if#_mac_address', 't', 'HardwareAddress' ], # 00:11:24:9E:73:CC
  [ 'if#_ip_address', 't', 'PrimaryIPAddresses' ], # 10.3.102.23
  [ 'if#_all_ip_addresses', 't', 'AllIPAddresses' ], # 10.3.102.23
  ] }

  ]
  
  def id
    Digest::MD5.digest([ self.computername, self.objectname, self.propertyname, 
      self.itemseq, self.value, self.lastupdated ].collect { |v| v.to_s }.join(''))
  end
  
  def id=(new_id)
  end
  
  class << self
    def all_computerids
      find(:all, :select => "DISTINCT computerid").map(&:computerid)
    end
    
    def all_machine_models
      find(:all, :select => "DISTINCT value", :conditions => ['propertyname LIKE ?', 'MachineModel']).map(&:value)
    end

    def find_by_attribute(objectname, propertyname, value)
      find(:all, :select => "DISTINCT computerid", 
        :conditions => ['objectname LIKE ? AND propertyname LIKE ? AND value LIKE ?', 
          objectname, propertyname, value]).map(&:computerid)
    end
    
    def find_by_machine_model(model)
      find_by_attribute('Mac_SystemInfoElement', 'MachineModel', model)
    end
    
    def attribute(computerid, objectname, propertyname, itemseq=0)
      r = find(:first, :select => 'value', :conditions => 
        ['computerid=? AND objectname LIKE ? AND propertyname LIKE ? AND itemseq=?', 
          computerid, objectname, propertyname, itemseq], :order => 'lastupdated DESC')
      r ? r.value : nil
    end
    
    def model_report
      models = { }
      all_computerids.each do |cid|
        model_attrs = system_attributes(cid)
        machine_model = model_attrs['MachineModel']
        machine_class = model_attrs['MachineClass']
        models[machine_model] ||= { 'count' => 0 }
        models[machine_model][machine_class] = 1
        models[machine_model]['count'] += 1
      end
      models
    end
    
    def system_attributes(computerid)
      model_attrs = { }
      updated = nil
      find(:all, :conditions => ['computerid=? AND objectname=? AND propertyname IN (?)', 
        computerid, 'Mac_SystemInfoElement', 
          ['MachineModel', 'MachineClass', 'ProcessorCount', 'ProcessorSpeed', 
          'ProcessorSpeedString', 'ComputerName', 'UnixHostName', 'MachineSerialNumber',
          'ARDComputerInfo1', 'ARDComputerInfo2', 'ARDComputerInfo3', 'ARDComputerInfo4'] ], 
        :order => 'objectname,itemseq,propertyname').each do |row|
        model_attrs[row.propertyname] = row.value
        updated ||= row.lastupdated
      end
      model_attrs['computerid'] = computerid
      model_attrs['updated'] = updated
      model_attrs
    end
    
    def all_attributes(computerid)
      ard_attrs = { }
      updated = nil
      find(:all, :conditions => ['computerid=?', computerid], :order => 'objectname,itemseq,propertyname').each do |row|
        ard_attrs[row.objectname] ||= [ ]
        ard_attrs[row.objectname][row.itemseq] ||= { }
        ard_attrs[row.objectname][row.itemseq][row.propertyname] = row.value
        updated ||= row.lastupdated
      end
      ard_attrs['computerid'] = computerid
      ard_attrs['updated'] = updated
      ard_attrs
    end
  end
end
