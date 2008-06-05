class Computer < Asset
  has_many :computer_list_members, :dependent => :delete_all
  has_many :computer_lists, :through => :computer_list_members
  belongs_to :machine_group
  belongs_to :nr_config
    
  def nr_machine_settings
    rend_name = self.unix_hostname
    rend_name = self.name.strip.downcase.gsub(/\s+/, '-') if rend_name.blank?
    settings = { :computerid => self.mac_address,
      :computer_name => self.name,
      :rendezvous_name => rend_name,
      # :classicAtalkName => nil,
      :ard_list_tag => '',
      :default_printer => '', # self.default_printer_name,
      :location => self.location,
      :asset_tag => self.barcode,
      :serial_number => self.serial_number }
    ip_options = Computer.get_ip_options(self.ip_address, self.network_location, self.network_port)
    settings.merge!(ip_options) if ip_options
    return HashWithIndifferentAccess.new(settings)
  end
  
  def nr_parameter
    mg = self.machine_group
    (mg && mg.nr_parameter) ? mg.nr_parameter : NrParameter.find(:first, :order => ['id'])
  end

  def nr_configuration
    mg = self.machine_group
    (mg && mg.nr_configuration) ? mg.nr_configuration : NrConfiguration.find(:first, :order => ['id'])
  end
  
  def edit_path
    :edit_computer_path
  end
  
  def coll_path
    :computers_path
  end
  
  def description_or_model
    description.blank? ? apple_model : description
  end
  
  def apple_model
    Computer.model_info(mfr_machine_model)['description'].gsub(/;.+$/, '...')
  end 
  
  def update_from_ard(attrs_to_exclude=[:name, :serial_number], on_serial_number=false, on_ip_address=false)
    computerid = nil
    ard_attrs = { }
    updated = nil
    result = false
    msg = nil
    if Asset.valid_mac_address?(mac_address)
      computerid, ard_attrs, updated = Computer.ard_db.record_for_id(mac_address)
      msg = "Could not find matching ARD record for MAC address #{mac_address}." if computerid.blank?
    end
    if computerid.blank? && on_serial_number && Asset.valid_serial_number?(serial_number)
      computerid, ard_attrs, updated = Computer.ard_db.record_for_serial_number(serial_number)
      msg = "Could not find matching ARD record for serial number #{serial_number}." if computerid.blank?
    end
    if computerid.blank? && on_ip_address && Asset.valid_ip_address?(ip_address)
      computerid, ard_attrs, updated = Computer.ard_db.record_for_ip_address(ip_address)
      msg = "Could not find matching ARD record for IP address #{ip_address}." if computerid.blank?
    end
    if !computerid.blank?
      attrs = Computer.get_ard_attributes(computerid, ard_attrs, updated, attrs_to_exclude)
      result = update_attributes(attrs)
      msg = "ARD update failed for id #{computerid}." unless result
    end
    [result, msg]
  end
  
  def add_to_machine_group(name)
    mg = MachineGroup.find_by_name(name)
    raise "machine group #{name} not found" unless mg
    Computer.connection.execute("INSERT INTO nr_parameters (computerid, machine_group_id) 
      VALUES ('#{mac_address}', #{mg.machine_group_id})")
    return true
  end
  
  class << self
    def add_kent_student_laptops
      clist = find(:all, :conditions => ["name REGEXP '^kent-[abcd]'"])
      clist.each { |c| c.add_to_machine_group('kent student laptops') }
    end
    
    def export_nr_csv(clist, fname='nr_machines.csv')
      fname = File.join(RAILS_ROOT, 'data', fname) unless fname[0] == '/'
      FasterCSV.open(fname, 'w', :force_quotes => true) do |csv|
          csv << ['computerid', 'computer_name', 'rendezvous_name',
            'ip_config_method', 'ip_address', 'subnet_mask', 'router_address', 'dns_entries',
            'location', 'user', 'asset_tag', 'serial_number']
          clist.each do |m|
            csv << [m.mac_address, m.name, m.unix_hostname,
              m.ip_config_method, m.ip_address, m.subnet_mask, m.router_address, m.dns_entries,
              m.location, m.user, m.barcode, m.serial_number ]
          end
        end      
    end
    
    def model_info(machine_model)
      @model_lookups ||= YAML.load_file(File.join(RAILS_ROOT, 'db/apple_machine_models.yml'))
      machine_model.blank? || !@model_lookups.key?(machine_model) ? 
        { 'description' => (machine_model || ''), 'tag_list' => '' } :
        @model_lookups[machine_model].merge('found' => true) 
    end
    
    def add_classroom_tags
      list = find_by_sql("SELECT assets.* FROM assets " +
      "INNER JOIN taggings ON taggings.taggable_id=assets.id " +
      "INNER JOIN tags ON tags.id=taggings.tag_id " +
      "WHERE assets.`type`='Computer' AND assets.status='active' AND " +
      "NOT assets.location LIKE '%office%' AND NOT assets.name REGEXP 'kent|bacich' AND " +
      "taggings.taggable_type='Asset' AND tags.name LIKE 'laptop'")
      list.each do |c|
        print "#{c.name} -> classroom\n"
        c.append_tags('classroom')
      end
      true
    end

    def import_ard_lists(dir=nil)
      dir = File.join(RAILS_ROOT, 'data/ard_lists') if dir.blank? 
      Dir.glob("#{dir}/*.plist") do |filename|
        ard_list_tag = File.basename(filename).gsub(/\.plist$/, '')
        import_ard_list(ard_list_tag, dir)
      end
    end
    
    def import_ard_list(ard_list_tag, dir=nil)
      dir = File.join(RAILS_ROOT, 'data/ard_lists') if dir.blank? 
      filename = File.join(dir, "#{ard_list_tag}.plist")
      
      r = Plist::parse_xml(filename)
      if r.nil?
        print "#{ard_list_tag}: parse error\n"
        next
      end
      if r['items'].nil?
        print "#{ard_list_tag}: no items\n"
        next
      end
      
      # get all machine records in list
      r['items'].each do |item|
        name = item['name'].strip
        print "#{ard_list_tag} - #{name}\n"
        mac_address = item['hardwareAddress']
        if !valid_mac_address? mac_address
          print "bad mac_address #{mac_address}\n"
          next
        end
        
        # standardize computer name
        computer_name = standardize_name(name)
        unix_hostname = computer_name.gsub(/\s+/, '-')
        # determine whether ip is manual, etc.
        ip_address = item['networkAddress']
        network_location = nil
        network_port = nil
        if computer_name.downcase.match(/(ibook|powerbook|macbook)/) &&
          ['bteachers','kteachers'].include?(ard_list_tag)
          network_location = 'KSD Airport'
          network_port = 'AirPort'
        end
        attrs = get_ip_options(ip_address, network_location, network_port)
        if attrs.nil?
          print "bad ip address #{ip_address}\n"
          next
        end
        
        attrs[:name]          = name
        attrs[:unix_hostname] = unix_hostname
        # update or insert record
        computer = find_through_mac_address(mac_address)
        if computer.nil?
          computer = Computer.create(attrs)
        else
          computer.update_attributes(attrs)
        end
        list = ComputerList.find_or_create_by_ard_list_tag(ard_list_tag)
        computer.computer_lists << list
      end
    end
    
    # note: ARD database needs to be set up with tcpip enabled and with a host line in pg_hba.conf
    def import_ard_db(attrs_to_exclude=[])
      ard_db.each do |computerid, ard_attrs, updated|
        print "computer: #{computerid}\n"
        print "machine_model: #{ArdDb.fetch(ard_attrs, 'Mac_SystemInfoElement', 'MachineModel')}\n"
        update_ard_attributes(computerid, ard_attrs, updated, attrs_to_exclude)
      end
    end
        
    # format of filemaker export record:
    # 0 barcode
    # 1 serial_number
    # 2 site
    # 3 name
    # 4 user
    # 5 location
    # 6 model_abbr
    # 7 model_apple
    # 8 notes
    # 9 mac_address
    # 10 battery_serial
    # 11 unix_hostname
    # 12 use
    # 13 ip_address
    
    def import_laptop_csv(fname='good_laptops.csv')
      fname = File.join(RAILS_ROOT, 'data', fname) unless fname[0] == '/'
      FasterCSV.foreach(fname, :col_sep => ',', :headers => false) do |row|
        name          = row[3]
        barcode       = row[0]
        description   = row[6]
        serial_number = row[1]
        print "#{description} - #{name} - #{barcode} - #{serial_number}\n"
        location      = [row[2], row[5]].join(' ').strip
        computer_name = standardize_name(name)
        user = row[4]
        ip_address = row[13]
        disposition_notes = nil
        tags = [ ]
        case description
        when /\/(ib|pb|mb)\//
          tags << 'laptop'
        when /\/(im|pm)\//
          tags << 'desktop'
        end
        usage = row[12].downcase
        status = 'active'
        case usage
        when /stolen/
          disposition_notes = row[12]
          status = 'stolen'
        when /missing/
          disposition_notes = row[12]
          status = 'missing'
        when /broken/
          disposition_notes = row[12]
          status = 'broken'
        when /teacher/
          tags << 'teacher'
        when /classroom/
          tags << 'classroom'
        when /office/
          tags << 'office'
        when /cart/
          tags << 'cart'
        else
          tags << usage unless usage.blank?
        end
        tag_list = tags.join(', ')
        attrs = { :status => status }
        attrs[:name]          = computer_name unless computer_name.blank?
        attrs[:barcode]       = barcode if valid_barcode? barcode
        attrs[:serial_number] = serial_number if valid_serial_number? serial_number
        attrs[:location]      = location unless location.blank?
        attrs[:user]          = user unless user.blank?
        attrs[:ip_address]    = ip_address if valid_ip_address? ip_address
        attrs[:disposition_notes] = disposition_notes
        attrs[:battery_serial_number] = row[10] unless row[10].blank?
        computer = nil
        computer = find_by_barcode(barcode) if valid_barcode?(barcode)
        computer = find_by_serial_number(serial_number) if computer.nil? && valid_serial_number?(serial_number)
        if computer.nil?
          computer = create(attrs)
          computer.tag_list = tag_list unless tag_list.blank?
          notes = row[8]
          if !notes.blank?
            computer.tickets.create(:description => notes)
          end
        else
          computer.update_attributes(attrs)
          computer.append_tags(tag_list) unless tag_list.blank?
        end
      end
    end
    
    def get_ard_attributes(mac_address, ard_attrs, collection_time, attrs_to_exclude)
      serial_number = ArdDb.fetch(ard_attrs, 'Mac_SystemInfoElement', 'MachineSerialNumber')
      machine_class = ArdDb.fetch(ard_attrs, 'Mac_SystemInfoElement', 'MachineClass') || ''
      machine_model = ArdDb.fetch(ard_attrs, 'Mac_SystemInfoElement', 'MachineModel') || 'Unknown'
      cpu_type = machine_class.gsub(/\s+\([\.0-9]+\)\s*$/, '')
      memory_size = ArdDb.fetch(ard_attrs, 'Mac_SystemInfoElement', 'PhysicalMemorySize') || '0'
      memory_mb =  memory_size.to_i / 1024
      disk_space = ArdDb.fetch(ard_attrs, 'Mac_SystemInfoElement', 'TotalHardDriveSpace') || '0.0'
      total_disk_space_gb = disk_space.to_f / (1024.0*1024.0)
      attrs = { :mac_address => mac_address,
        :mfr_machine_model    => machine_model,
        :rom_version          => ArdDb.fetch(ard_attrs, 'Mac_SystemInfoElement', 'BootROMVersion'),
        :cpu_type             => cpu_type,
        :cpu_speed_mhz        => ArdDb.fetch(ard_attrs, 'Mac_SystemInfoElement', 'ProcessorSpeed'),
        :processor_count      => ArdDb.fetch(ard_attrs, 'Mac_SystemInfoElement', 'ProcessorCount'),
        :memory_mb            => memory_mb,
        :total_disk_space_gb  => total_disk_space_gb,
        :default_printer_name => ArdDb.fetch(ard_attrs, 'Mac_SystemInfoElement', 'SelectedPrinterName'),
        :ard_data_last_collected_at => collection_time }
      optical_drive = ArdDb.fetch(ard_attrs, 'Mac_SystemInfoElement', 'OpticalDriveType')
      attrs[:optical_drive_type] = optical_drive unless optical_drive.blank?
      if valid_serial_number?(serial_number) && !attrs_to_exclude.include?(:serial_number)
        attrs[:serial_number] = serial_number
      end
      name = ArdDb.fetch(ard_attrs, 'Mac_SystemInfoElement', 'ComputerName')
      if !name.blank? && !attrs_to_exclude.include?(:name)
        computer_name = standardize_name(name)
        unix_hostname = computer_name.gsub(/\s+/, '-')
        attrs[:name]  = name
        attrs[:unix_hostname] = unix_hostname
      end
      return attrs
    end
      
    def update_ard_attributes(mac_address, ard_attrs, collection_time, attrs_to_exclude)
      attrs = get_ard_attributes(mac_address, ard_attrs, collection_time, attrs_to_exclude)
      info = model_info(attrs[:mfr_machine_model])
      print " model: #{info['description']}\n tags: #{info['tag_list']}\n"
      
      # look for match first by mac_address, then by serial number, otherwise: new record
      computer = find_through_mac_address(mac_address)
      computer = find_by_serial_number(serial_number) if computer.nil? && valid_serial_number?(serial_number)
      if computer.nil?
        computer = create(attrs)
        computer.tag_list = info['tag_list'] unless info['tag_list'].blank?
      else
        computer.update_attributes(attrs)
        if !info['tag_list'].blank?
          computer.append_tags(info['tag_list'])
        end
      end
    end
    
    def get_ip_options(ip_addr, network_location=nil, network_port=nil)
      ip_method = 'DHCP'
      if valid_ip_address?(ip_addr)
        ip_method = 'Manual'
        network_location ||= 'KSD Ethernet'
        network_port ||= 'Built-in Ethernet'
        octets = ip_addr.split('.')
        if network_port == 'AirPort' || (octets[0] == '10' && octets[2].to_i >= 110)
          ip_method = 'DHCP'
          network_location = 'KSD Airport'
          network_port = 'AirPort'
        end
      end
      
      case ip_method
      when 'DHCP'
        network_location ||= 'Automatic'
        network_port ||= 'Built-in Ethernet'
        return { :ip_config_method => ip_method,
          # :ip_address => ip_addr,
          # :subnet_mask => subnet_mask,
          # :router_address => router_address,
          # :dns_entries => '10.4.51.70 10.4.51.68',
          # :dhcp_id => nil,
          :network_location => network_location,
          :network_port => network_port
        }        
      when 'Manual'
        case octets[0]
        when '64'
          return nil if !(octets[1] == '171' && octets[2] == '175')
          return { :ip_config_method => ip_method,
            :ip_address => ip_addr,
            :subnet_mask => '255.255.255.240',
            :router_address => '64.171.175.66',
            :dns_entries => '199.88.112.10',
            # :dhcp_id => nil,
            :network_location => network_location,
            :network_port => network_port
          }
        when '10'
          subnet_mask = '255.255.0.0'
          router_address = nil
          case octets[1]
          when '3'
            router_address = '10.3.254.253'
            return { :ip_config_method => ip_method,
              :ip_address => ip_addr,
              :subnet_mask => subnet_mask,
              :router_address => router_address,
              :dns_entries => '10.3.51.73 10.4.51.70',
              # :dhcp_id => nil,
              :network_location => network_location,
              :network_port => network_port
            }
          when '4'
            router_address = '10.4.254.254'
            return { :ip_config_method => ip_method,
              :ip_address => ip_addr,
              :subnet_mask => subnet_mask,
              :router_address => router_address,
              :dns_entries => '10.4.51.70 10.4.51.68',
              # :dhcp_id => nil,
              :network_location => network_location,
              :network_port => network_port
            }
          end
        end
      end
    end
  end
  
end

