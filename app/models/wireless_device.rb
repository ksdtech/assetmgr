class WirelessDevice < Asset
  
  def edit_path
    :edit_wireless_item_path
  end
  
  def coll_path
  	:wireless_path
  end

  class << self
    def import_csv(fname='airports.csv')
      fname = File.join(RAILS_ROOT, 'data', fname) unless fname[0] == '/'
      FasterCSV.foreach(fname, :col_sep => ',',
        :headers => true, :header_converters => :symbol) do |row|
        raw = row.to_hash
        description = 'AirPort Extreme'
        name        = raw[:name]
        print "#{description} - #{name}\n"
        mac_address = raw[:mac_ap]
        next unless valid_mac_address? mac_address
        ip_address  = raw[:ip]
        location    = name.tr('-', ' ')
        tag_list = '802.11b, 802.11g'
        attrs = { :description => description,
          :rom_version   => raw[:fw],
          :status        => 'active' }
        attrs[:name]        = name unless name.blank?
        attrs[:mac_address] = mac_address
        attrs[:ip_address]  = ip_address if valid_ip_address? ip_address
        attrs[:location]    = location unless location.blank?
        dev = nil
        dev = find_through_mac_address(mac_address)
        if dev.nil?
          dev = create(attrs)
          dev.tag_list = tag_list unless tag_list.blank?
          dev.ethers.create(:interface_id => 'en0',
            :mac_address => raw[:mac_wan],
            :media_type => 'cat5')
          dev.ethers.create(:interface_id => 'en1',
            :mac_address => raw[:mac_lan],
            :media_type => 'cat5')
          dev.ethers.create(:interface_id => 'wl0',
            :mac_address => raw[:mac_ap],
            :media_type => 'wireless')
        else
          dev.update_attributes(attrs)
          dev.append_tags(tag_list) unless tag_list.blank?
        end
      end
    end
  end
  
end
