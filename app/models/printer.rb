class Printer < Asset
  PRT_MARKER_LIFE_COUNT_1_1 = '1.3.6.1.2.1.43.10.2.1.4.1.1'
  
  def edit_path
    :edit_printer_path
  end
  
  def coll_path
  	:printers_path
  end
  
  def name_validation?
    false
  end
  
  def snmp_poll
    t = nil
    if !ip_address.blank?
      begin
        admin_user = User.find(:first, :conditions => ['administrator=1'])
        snmp_category = TicketCategory.find_or_create_by_name('_SNMP')
        snmp = SNMP::Manager.new(:Host => self.ip_address, :Timeout => 0.5)
        response = snmp.get([PRT_MARKER_LIFE_COUNT_1_1])
        response.each_varbind do |vb|
          begin
            page_count = vb.value.to_i
            t = tickets.build(
              :requestor       => admin_user,
              :ticket_category => snmp_category,
              :priority        => Ticket::PRIORITY_LOW,
              :importance      => Ticket::PRIORITY_LOW,
              :status          => Ticket::STATUS_POLLED,
              :subject         => 'Page Count',
              :description     => 'Created by system: Printer#snmp_poll',
              :page_count      => page_count)
            t.save!
            puts "printer #{self.ip_address} - created page count ticket #{t.id}"
          rescue
            puts "printer #{self.ip_address} - ticket failed: #{$!}"
            t = nil
          end
        end
      rescue
        # SNMP::RequestTimeout, etc.
        puts "printer #{self.ip_address} - snmp request failed: #{$!}"
      end
    end
    t
  end
  
  class << self
    def import_csv(fname='printers.csv')
      fname = File.join(RAILS_ROOT, 'data', fname) unless fname[0] == '/'
      FasterCSV.foreach(fname, :col_sep => ',',
        :headers => true, :header_converters => :symbol) do |row|
        raw = row.to_hash
        tag_list = nil
        case raw[:rtype]
        when /^rc/
          tag_list = 'laser, color'
        when /^rl/
          tag_list = 'laser'
        else
          next
        end
        
        description   = raw[:description]
        name          = raw[:appletalk]
        barcode       = raw[:tag]
        serial_number = raw[:serial]
        mac_address   = raw[:mac]
        ip_address    = raw[:ip_address]
        print "#{description} - #{name} - #{barcode} - #{serial_number}\n"
        location      = [raw[:site], raw[:location]].join(' ').strip
        attrs = { :description => description,
          :status => (raw[:active].downcase == 'y') ? 'active' : 'inactive' }
        attrs[:name]          = name unless name.blank?
        attrs[:barcode]       = barcode if valid_barcode? barcode
        attrs[:serial_number] = serial_number if valid_serial_number? serial_number
        attrs[:mac_address]   = mac_address if valid_mac_address? mac_address
        attrs[:ip_address]    = ip_address if valid_ip_address? ip_address
        attrs[:location]      = location unless location.blank?
        printer = nil
        printer = find_by_barcode(barcode) if valid_barcode?(barcode)
        printer = find_by_serial_number(serial_number) if printer.nil? && valid_serial_number?(serial_number)
        printer = find_through_mac_address(mac_address) if printer.nil? && valid_mac_address?(mac_address)
        if printer.nil?
          printer = create(attrs)
          printer.tag_list = tag_list unless tag_list.blank?
        else
          printer.update_attributes(attrs)
          printer.append_tags(tag_list) unless tag_list.blank?
        end
        page_count = raw[:pages]
        printer.tickets.create(:description => 'Inventoried for page count',
          :status => 'ok',
          :page_count => page_count) if !page_count.nil?
      end
    end
    
    def snmp_poll
      find(:all, :conditions => ["status='active' AND ip_address<>'' AND snmp_printmib=1"]).each do |prt|
        prt.snmp_poll
      end
    end
  end
  
end

