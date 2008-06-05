class ArdSystemInfo < ActiveRecord::Base
  set_table_name :systeminformation
  establish_connection :ard
  
  SYSTEM_INFO_PROPERTIES = [
    [ 'PrimaryNetworkHardwareAddress',  'computerid',  :string,  { :limit => 17, :null => false } ], # 00:14:51:06:F3:76
    [ 'MachineSerialNumber', 'serial_number',          :string,  { } ], # 4H52602CS87
    [ 'ComputerName',        'appletalk_name',         :string,  { } ], # bacich-b23
    [ 'UnixHostName',        'mdns_hostname',          :string,  { } ], # bacich-b23
    [ 'MachineModel',        'machine_model',          :string,  { } ], # PowerBook6,5
    [ 'MachineClass',        'machine_class',          :string,  { } ], # PowerPC G4  (1.2)
    [ 'ProcessorCount',      'processor_count',        :integer, { } ], # 1
    [ 'ProcessorType',       'processor_type',         :string,  { } ], # 275
    [ 'ProcessorSpeed',      'processor_speed',        :integer, { } ], # 1200
    [ 'BusSpeed',            'bus_speed',              :float,   { } ], # 133.12199401855469
    [ 'PhysicalMemorySize',  'physical_memory_size',   :integer, { } ], # 524288
    [ 'SystemVersionString', 'system_version_string',  :string,  { } ], # Mac OS X 10.4.2 (8C46)
    [ 'ARDComputerInfo1',    'ard_info_1',             :string,  { } ],
    [ 'ARDComputerInfo2',    'ard_info_2',             :string,  { } ],
    [ 'ARDComputerInfo3',    'ard_info_3',             :string,  { } ],
    [ 'ARDComputerInfo4',    'ard_info_4',             :string,  { } ],
  ]
  
  HARD_DRIVE_PROPERTIES = [
    [ 'UnixMountPoint',      'hd#_mount_point',        :string,  { } ], # /dev/disk0s3
    [ 'Model',               'hd#_model',              :string,  { } ], # FUJITSU MHT2030AT
    [ 'TotalSize',           'hd#_total_size',         :integer, { } ], # 29171400
    [ 'FreeSpace',           'hd#_free_space',         :integer, { } ], # 21614400
    [ 'Protocol',            'hd#_protocol',           :string,  { } ], # ATA
    [ 'RemovableMedia',      'hd#_removable',          :boolean, { } ], # false
    [ 'IsBootVolume',        'hd#_boot_volume',        :boolean, { } ], # true
  ]

  RAM_SLOT_PROPERTIES = [
    [ 'SlotIdentifier',      'ram#_id',                :string,  { } ], # DIMM0/BUILT-IN
    [ 'MemoryModuleSize',    'ram#_module_size',       :string,  { } ], # 256 MB
  ]
  
  NETWORK_INTERFACE_PROPERTIES = [
    [ 'InterfaceName',       'if#_name',               :string,  { } ],   # en1
    [ 'IsPrimary',           'if#_primary',            :boolean, { } ],   # true
    [ 'ConfigurationName',   'if#_configuration_name', :string,  { } ],   # AirPort, Built-in Ethernet
    [ 'ConfigurationType',   'if#_configuration_type', :string,  { } ],   # AirPort, Ethernet
    [ 'HardwareAddress',     'if#_mac_address',        :string,  { } ],   # 00:11:24:9E:73:CC
    [ 'PrimaryIPAddresses',  'if#_ip_address',         :string,  { } ],   # 10.3.102.23
    [ 'AllIPAddresses',      'if#_all_ip_addresses',   :string,  { } ],   # 10.3.102.23
  ]

  ARD_FIELDS = [
    # system information
    { 'object' => 'Mac_SystemInfoElement',
      'maxcount' => 1,
      'is_system' => true,
      'fields' => SYSTEM_INFO_PROPERTIES
    },
    # for each hard disk, keyed on UnixMountPoint
    { 'object' => 'Mac_HardDriveElement',
      'maxcount' => 4,
      'is_system' => false,
      'fields' => HARD_DRIVE_PROPERTIES 
    },
    # for each RAM slot, keyed on SlotIdentifier
    { 'object' => 'Mac_RAMSlotElement',
      'maxcount' => 4,
      'is_system' => false,
      'fields' => RAM_SLOT_PROPERTIES
    },
    # for ethernet and airport ConfigurationType only, keyed on InterfaceName
    { 'object' => 'Mac_NetworkInterfaceElement',
      'maxcount' => 4,
      'is_system' => false,
      'fields' => NETWORK_INTERFACE_PROPERTIES
    }
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
    
    def system_property_names
      SYSTEM_INFO_PROPERTIES.collect { |propname, colname, coltype, options| propname }
    end
    
    def ard_record_column(propertyname)
      SYSTEM_INFO_PROPERTIES.each do |propname, colname, coltype, options|
        return [colname, coltype, options] if propname == propertyname
      end
      return nil
    end
    
    def system_attributes(computerid, convert_values=false)
      model_attrs = { }
      updated = nil
      find(:all, :conditions => ['computerid=? AND objectname=? AND propertyname IN (?)', 
        computerid, 'Mac_SystemInfoElement', system_property_names ], 
        :order => 'objectname,itemseq,propertyname').each do |row|
        if convert_values
          colname, coltype, options = ard_record_column(row.propertyname)
          if !colname.nil?
            model_attrs[colname] = case coltype
            when :boolean
              (row.value.nil? || row.value.to_i == 0) ? false : true
            when :integer
              row.value.nil? ? 0 : row.value.to_i
            when :float
              row.value.nil? ? 0.0 : row.value.to_f
            else
              row.value
            end
          end
        else
          model_attrs[row.propertyname] = row.value
        end
        updated ||= row.lastupdated
      end
      if !convert_values
        model_attrs['computerid'] = computerid
        model_attrs['updated'] = updated
      end
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

