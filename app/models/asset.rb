class Asset < ActiveRecord::Base
  include SearchableRecord
  
  STATUS_OPTIONS = ['', 'active', 'inactive', 'broken', 'stolen', 'lost', 'missing', 'surplus', 'surplus200803', 'returned', 'disposed', 'bad record', 'unknown']
  NETWORK_LOCATION_OPTIONS = ['', 'KSD Ethernet', 'KSD Airport', 'Automatic']
  NETWORK_PORT_OPTIONS = ['Built-in Ethernet', 'AirPort']
  IP_PATTERN = /^$|\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\Z/
  MAC_PATTERN = /^$|\A([0-9a-f]{2})(\:)?([0-9a-f]{2})(\:)?([0-9a-f]{2})(\:)?([0-9a-f]{2})(\:)?([0-9a-f]{2})(\:)?([0-9a-f]{2})\Z/i
  BARCODE_PATTERN = /^\A[0-9]{6}KSD\Z/
  
  acts_as_taggable
  has_many :ethers, :dependent => :delete_all
  has_many :tickets, :dependent => :delete_all
  has_many :inventory_marks, :dependent => :delete_all
  has_many :inventories, :through => :inventory_marks
  before_save :do_validation_processing
  after_save :update_inventory_mark
  
  validates_presence_of :manufacturer
  validates_format_of :ip_address,  :with => IP_PATTERN
  validates_format_of :mac_address, :with => MAC_PATTERN
  validates_each :name do |record, attr, value|
    record.errors.add attr, 'cannot be parsed' if record.name_validation? &&
      !value.blank? && !Asset.valid_name?(value)
  end
  validates_each :location do |record, attr, value|
    record.errors.add attr, 'cannot be parsed' if record.location_validation? &&
      !value.blank? && !Asset.valid_location?(value)
  end
  
  def associated_ard_record
    nil
  end
  
  def duplicate_barcode_exists?
    return false if barcode.blank?
    sql = "SELECT COUNT(*) FROM assets WHERE barcode = '#{self.barcode}' AND id <> #{self.id}"
    duplicates = Asset.find_by_sql(sql)
    return duplicates.first['COUNT(*)'].to_i > 0
  end
  
  def duplicate_serial_number_exists?
    return false if serial_number.blank?
    sql = "SELECT COUNT(*) FROM assets WHERE REPLACE(serial_number, 'O', '0') LIKE REPLACE('#{self.serial_number}', 'O', '0') AND id <> #{self.id}"
    duplicates = Asset.find_by_sql(sql)
    return duplicates.first['COUNT(*)'].to_i > 0
  end
  
  def duplicate_mac_address_exists?
    return false if mac_address.blank?
    sql = "SELECT COUNT(*) FROM assets WHERE mac_address = '#{self.mac_address}' AND id <> #{self.id}"
    duplicates = Asset.find_by_sql(sql)
    return duplicates.first['COUNT(*)'].to_i > 0
  end
  
  def duplicate_ip_address_exists?
    return false if ip_address.blank?
    sql = "SELECT COUNT(*) FROM assets WHERE ip_address = '#{self.ip_address}' AND id <> #{self.id}"
    duplicates = Asset.find_by_sql(sql)
    return duplicates.first['COUNT(*)'].to_i > 0
  end

  def save_ethers(old_ethers, new_ethers)
    created = 0
    updated = 0
    deleted = 0
    if !old_ethers.nil?
      old_ethers.each_pair do |eid, eparams|
        e = Ether.find(eid)
        if eparams['mac_address'].blank?
          e.destroy
          deleted += 1
        else
          e.update_attributes(eparams)
          updated += 1
        end
      end
    end
    if !new_ethers.nil?
      new_ethers.each_pair do |i, eparams|
        eparams['mac_address'] = Asset.format_mac_address(eparams['mac_address'])
        if !eparams['mac_address'].blank?
          self.ethers.create(eparams)
          created += 1
        end
      end
    end
    [ created, updated, deleted ]
  end
  
  def name_or_id
    self.name.blank? ? "#{self.item_type} (#{self.id})" : self.name
  end
  
  def title
    "#{self.name} (#{self.id})".strip
  end
  
  def option_text
    fields = [ self.barcode, self.serial_number, self.name, self.description].select { |t| !t.blank? }.join(" / ")
    "#{fields} (#{self.id})"
  end

  def description_or_model
    description
  end
  
  def item_type
    item_class.blank? ? self['type'] : item_class
  end

  def active?
    status == 'active'
  end
  
  def inventoried?
    begin
      return true if !Asset.current_inventory.assets.find(self.id).nil?
    rescue
    end
    false
  end
  
  def inventoried
    inventoried?
  end
  
  def inventoried=(inv)
  	# the actual call to inventory! must be postponed for new records
  	@add_to_inventory = (!inv.nil? && !inv.to_i.zero?)
  end
  
  def inventory!
    Asset.current_inventory.assets << self
    # raise "#{self.id} was added to inventory #{Asset.current_inventory.id}"
  end
  
  def update_inventory_mark
  	inventory! if @add_to_inventory
  	@add_to_inventory = false
  end
  
  def do_validation_processing
    write_attribute(:mac_address, Asset.format_mac_address(self.mac_address))
    set_unix_hostname
    split_name     if name_validation?
    split_location if location_validation?
  end
  
  def name_validation?
    true
  end
  
  def set_unix_hostname
    if unix_hostname.blank?
      std_name = Asset.standardize_name(name)
      unix_name = std_name.blank? ? nil : std_name.gsub(/\s+/, '-')
      write_attribute(:unix_hostname, unix_name)
    end
  end
  
  def split_name
    std_name = Asset.standardize_name(name)
    std_name, p, ind = Asset.parse_name(std_name)
    # print "#{name} validated to #{std_name}\n"
    if !p.nil? || std_name.nil?
      write_attribute(:name, std_name)
      write_attribute(:name_prefix, p)
      write_attribute(:name_index, ind)
    end
  end
  
  def location_validation?
    true
  end
  
  def split_location
    locstr, site, p, ind, s = Asset.parse_location(location)
    # print "#{location} validated to #{locstr}\n"
    if !site.nil? || locstr.nil?
      write_attribute(:location, locstr)
      write_attribute(:location_site, site)
      write_attribute(:location_prefix, p)
      write_attribute(:location_index, ind)
      write_attribute(:location_suffix, s)
    end
  end
  
  def update_barcode_by_serial_number
    if !Asset.valid_serial_number? serial_number
      tickets.create(:description => 'Updating barcode, but asset is missing serial number')
    else
      begin
        ar = AssetRecord.find_by_serialnum(serial_number)
      rescue
        tickets.create(:description => 'Updating barcode, but no inventory tag found in asset records')
      end
    end
  end
  
  class << self
    def per_page
      30 
    end
    
    def find_options(tag)
      tag.blank? ? { } : tagged_find_options
    end

    def tagged_find_options
      { :joins => "INNER JOIN taggings ON taggings.taggable_id=assets.id INNER JOIN tags ON tags.id=taggings.tag_id",
        :conditions => "taggings.taggable_type='Asset'" }
    end

    def search_rules
      {
        :query    => nil, # flag
        :page     => nil, # flag
        :offset   => nil, # flag
        :sort     => { 
          'id'       => 'assets.id',
          'name'     => 'assets.name',
          'barcode'  => 'assets.barcode',
          'serial'   => 'assets.serial_number',
          'model'    => 'assets.description',
          'status'   => 'assets.status',
          'user'     => 'assets.user',
          'location' => 'assets.location' },
        :rsort    => nil,                 # rsort is allowed according to rules in :sort (key as a flag)
        :patterns => { 
          :status   => {
            :conditions => 'assets.status LIKE :status', :converter => lambda { |val| val } },
          :loc      => 'assets.location',
          :tag      => {
            :conditions => 'tags.name LIKE :tag', :converter => lambda { |val| val } },
          :query    => {
            :conditions => 'assets.name LIKE :query OR assets.barcode LIKE :query OR assets.serial_number LIKE :query OR assets.manufacturer LIKE :query OR assets.description LIKE :query OR assets.user LIKE :query OR assets.ip_address LIKE :query OR assets.mac_address LIKE :query' 
          }
        }
      }
    end

    def find_duplicate_barcodes
      sql = "SELECT barcode, COUNT(*) FROM assets WHERE barcode <> '' GROUP BY barcode HAVING COUNT(*) > 1"
      duplicates = Asset.find_by_sql(sql)
      duplicates.collect { |d| Asset.find(:all, :select => 'id', :conditions => ['barcode LIKE ?', d['barcode'] ]) }.flatten.collect { |d| d.id }
    end
    
    def find_duplicate_serial_numbers
      sql = "SELECT REPLACE(serial_number, 'O', '0') AS fuzzy_serial, COUNT(*) FROM assets WHERE serial_number <> '' GROUP BY fuzzy_serial HAVING COUNT(*) > 1"
      duplicates = Asset.find_by_sql(sql)
      duplicates.collect { |d| Asset.find(:all, :select => 'id', :conditions => ["REPLACE(serial_number, 'O', '0') LIKE ?", d['fuzzy_serial'] ]) }.flatten.collect { |d| d.id }
    end
    
    def find_duplicate_mac_addresses
      sql = "SELECT mac_address, COUNT(*) FROM assets WHERE mac_address <> '' GROUP BY mac_address HAVING COUNT(*) > 1"
      duplicates = Asset.find_by_sql(sql)
      duplicates.collect { |d| Asset.find(:all, :select => 'id', :conditions => ['barcode LIKE ?', d['barcode'] ]) }.flatten.collect { |d| d.id }
    end
    
    def find_duplicate_ip_addresses
      sql = "SELECT ip_address, COUNT(*) FROM assets WHERE ip_address <> '' GROUP BY ip_address HAVING COUNT(*) > 1"
      duplicates = Asset.find_by_sql(sql)
      duplicates.collect { |d| Asset.find(:all, :select => 'id', :conditions => ['barcode LIKE ?', d['barcode'] ]) }.flatten.collect { |d| d.id }
    end
    
    def standardize_name(namestr)
      # 1: all lowercase, strip off domains
      # 2: remove hyphens
      # 3: remove punctuation (except remaining hyphens)
      namestr = '' if namestr.nil?
      namestr = namestr.downcase.gsub(/\.(kentfieldschools\.org|local)$/, '').
        gsub(/[-]?([0-9]+|room|emac|ibook|ilamp|imac|macbook|powerbook|powermac)[-]?/, ' \1 ').
        gsub(/[^-a-z0-9]/, ' ').gsub(/\s+/, ' ').strip
      namestr.blank? ? nil : namestr
    end
    
    def parse_name(namestr)
      prefix = nil
      ind = nil
      namestr = '' if namestr.nil?
      namestr.strip!
      words = namestr.split
      if words.size > 0
        if words[words.size-1].match(/^[0-9]+$/)
          prefix = words[0, words.size-1].join(' ')
          ind = words[words.size-1].to_i
        else
          prefix = words.join(' ')
        end
      end
      namestr = nil if namestr.blank?
      [ namestr, prefix, ind ]
    end
    
    def valid_name?(name)
      std_name = standardize_name(name)
      std_name, p, ind = parse_name(std_name)
      return !p.nil?
    end
    
    def parse_location(locstr)
      site = nil
      prefix = nil
      ind = nil
      suffix = nil
      locstr = '' if locstr.nil?
      locstr.strip!
      words = locstr.split
      if words.size > 0
        case words[0].downcase
        when 'kent' 
          site = 'Kent'
          words.shift
        when 'bacich'
          site = 'Bacich'
          words.shift
        when 'district'
          site = 'District'
          words.shift
        when 'other'
          site = 'Other'
          words.shift
        end
        if words.size > 0
          ind_m = nil
          ind_i = nil
          words.each_index do |i|
            m = words[i].match(/^([0-9]+)([ABCDE]?)$/)
            if m
              ind_m = m
              ind_i = i
            end
          end
          if ind_i.nil?
            prefix = words.join(' ')
          else
            prefix = (ind_i == 0) ? 'Room' : words[0, ind_i].join(' ')
            ind = ind_m[1].to_i
            words.insert(ind_i+1, ind_m[2]) if !ind_m[2].blank?
            ind_i += 1
            suffix = words[ind_i, words.size-ind_i].join(' ') if ind_i < words.size
          end
        end
      end
      locstr = nil if locstr.blank?
      [ locstr, site, prefix, ind, suffix ]
    end

    def valid_location?(location)
      locstr, site, p, ind, s = parse_location(location)
      return !site.nil?
    end
        
    def valid_barcode?(code)
      !code.blank? && code.match(BARCODE_PATTERN)
    end
    
    def valid_serial_number?(code)
      !code.blank? && !code.match(/unknown|missing|[\?]/i)
    end
    
    def valid_mac_address?(addr)
      !addr.blank? && addr.match(MAC_PATTERN)
    end
    
    def format_mac_address(addr)
      return '' if addr.blank?
      m = addr.match(MAC_PATTERN)
      return '' unless m
      "#{m[1]}:#{m[3]}:#{m[5]}:#{m[7]}:#{m[9]}:#{m[11]}".downcase
    end
    
    def valid_ip_address?(addr)
      !addr.blank? && addr != '0.0.0.0' && addr.match(IP_PATTERN)
    end
    
    def sort_order(sort_params)
      nil
    end
  
    def current_inventory
      @cur_inventory ||= ApplicationSetting.find(:first).current_inventory
    end
    
    def find_through_mac_address(addr)
      asset = find_by_mac_address(addr)
      if asset.nil?
        eth = Ether.find_by_mac_address(addr)
        asset = eth.asset unless eth.nil?
      end
      asset
    end
    
    def update_barcodes_by_serial_number
      find(:all).each do |asset|
        asset.find_barcode_by_serial_number
      end
    end

    def remove_all_data
      ComputerList.destroy_all
      Asset.destroy_all
      Tag.destroy_all
      AssetRecord.destroy_all
    end
    
  end
end
