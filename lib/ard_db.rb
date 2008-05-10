require 'postgres'

MAC_MODELS = {
  'iMac' => 'iMac G3', #' 266-333',
  'PowerBook3,4' => 'PowerBook G4', # ' 667-800 (4,1)',
  'PowerBook4,3' => 'iBook G3', #' 700 (4,3)',
  'PowerBook6,5' => 'iBook G4', #' 1.2 (6,5)',
  'PowerBook6,7' => 'iBook G4', #' 1.42 (6,7)',
  'PowerMac2,1' => 'iMac G3', #' 350-400 (2,1)',
  'PowerMac2,2' => 'iMac G3', #' 350-500 (2,2)',
  'PowerMac3,3' => 'PowerMac G4', #' (3,3)',
  'PowerMac4,1' => 'iMac G3', #' 500-600 (4,1)',
  'PowerMac4,2' => 'iMac G4', #' 700 (4,2)',
  'PowerMac4,4' => 'eMac G4', #' 700-800 (4,4)',
  'PowerMac6,3' => 'iMac G4', #' 1.25 (6,3)',
  'PowerMac6,4' => 'eMac G4', #' 1.0-1.25 (6,4)',
  'PowerMac7,2' => 'PowerMac G5', #' 2.0 (7,2)',
  'PowerMac8,1' => 'iMac G5', #' 1.8 (8,1)',
  'PowerMac8,2' => 'iMac G5', #' 1.8-2.0 (8,2)',
  'PowerMac11,2' => 'PowerMac G5', #' 2.0 (11,2)',
  'PowerMac12,1' => 'iMac G5', #' iSight (12,1)',
  'RackMac3,1' => 'Xserve G5', #' 2.3 (3,1)',    
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
[ 'serialnum', 't', 'MachineSerialNumber' ], # 4H52602CS87
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
  'prefixes' => [ '_airport', '_ethernet1', '_ethernet2', '_ethernet3' ],
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

class ArdDb
  attr_reader :pg_conn
  
  # Notes about accessing ARD data
  # 1. Apple Remote Desktop runs postgresql on port 5433
  # 2. Use ADAM tool from bombich.com to enable TCP/IP access
  # 3. /var/db/RemoteManagement/RMDB/rmdb.data/postgresql.conf must have:
  #    tcpip_socket = true
  # 4. /var/db/RemoteManagement/RMDB/rmdb.data/pg_hba.conf must be set to network access to ard database:
  #    host ard ard <IP-address> <IP-mask> password
  # with <IP-address> and <IP-mask> set appropriately, such as:
  #    host ard ard 10.0.0.0 255.0.0.0 password
  # Look in /var/db/RemoteManagement/RMDB/rmdb.data/password.txt to find the password!
  # 5. Common configuration errors:
  #    PGError: could not connect to server: Connection refused
  #    PGError: FATAL:  No pg_hba.conf entry for host 10.4.202.30, user ard, database ard
  def initialize(host='127.0.0.1', password='96k1jE26w2', port=5433, database='ard', username='ard')
    @pg_conn = PGconn.new(host, port, nil, nil, database, username, password)
  end
  
  def all_computer_ids
    return [ ] unless @pg_conn
    res = @pg_conn.exec('SELECT DISTINCT computerid FROM systeminformation')
    return res.collect { |row| row[0] }
  end

  def all_models
    return [ ] unless @pg_conn
    res = @pg_conn.exec("SELECT DISTINCT value FROM systeminformation WHERE propertyname='MachineModel'")
    return res.collect { |row| row[0] }
  end

  def dump_models
    all_models.each { |m| print "#{m}\n" }
  end

  def record_for_ip_address(ip_address)
    if @pg_conn
      sql = "SELECT DISTINCT computerid FROM systeminformation " +
   		"WHERE objectname='Mac_NetworkInterfaceElement' AND propertyname='PrimaryIPAddress' AND value='#{ip_address}' "
      res = @pg_conn.exec(sql)
      if res.nil?
        raise "error: #{$!}\n"
      elsif res.num_tuples >= 1
        computerid = res.result[0][0]
        # print "found #{computerid} for #{ip_address}\n"
        return record_for_id(computerid)
      end
    end
    return [nil, nil, nil]
  end
    
  def record_for_serial_number(serial_number)
    if @pg_conn
      sql = "SELECT DISTINCT computerid FROM systeminformation " +
        "WHERE objectname='Mac_SystemInfoElement' AND propertyname='MachineSerialNumber' AND value='#{serial_number}'"
      res = @pg_conn.exec(sql)
      if res.nil?
        raise "error: #{$!}\n"
      elsif res.num_tuples >= 1
        computerid = res.result[0][0]
        # print "found #{computerid} for #{serial_number}\n"
        return record_for_id(computerid)
      end
    end
    return [nil, nil, nil]
  end

  def record_for_id(computerid)
    return [nil, nil, nil] unless @pg_conn
    sql = "SELECT objectname,propertyname,itemseq,value,lastupdated FROM systeminformation " +
      "WHERE computerid='#{computerid}' ORDER BY objectname,propertyname,itemseq"
    res = @pg_conn.exec(sql)
    ard_attrs = { }
    updated = nil
    res.each do |row|
      objectname, propertyname, itemseq, value, updated = row
      itemseq = itemseq.to_i
      ard_attrs[objectname] = { } unless ard_attrs.key? objectname
      ard_attrs[objectname][propertyname] = [ ] unless ard_attrs[objectname].key? propertyname
      ard_attrs[objectname][propertyname][itemseq.to_i] = value
      if updated.nil?
        year, mon, mday, hour, min, sec, zone, wday = ParseDate::parsedate(updated, true)
        updated = DateTime.new(year, mon, mday, hour, min, sec)
      end
    end
    return [computerid, ard_attrs, updated]
  end
  
  def each
    @computerids ||= all_computer_ids
    @computerids.each do |computerid|
      yield record_for_id(computerid)
    end
  end

  def ArdDb.fetch(ard_attrs, obj, prop, ind=0)
    return ard_attrs[obj][prop][ind] rescue nil
  end
end
