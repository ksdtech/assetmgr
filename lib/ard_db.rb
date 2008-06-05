require 'postgres'

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
