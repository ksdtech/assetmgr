class AssetRecord < ActiveRecord::Base
  include SearchableRecord

  def self.per_page
    30
  end
  
  def self.search_rules
    {
      :page     => nil, # flag
      :offset   => nil, # flag
      :sort     => { 
        'barcode'  => 'asset_records.barcode',
        'serial'   => 'asset_records.serialnum',
        'make'     => 'asset_records.make',
        'model'    => 'asset_records.model',
        'site'     => 'asset_records.sitename',
        'room'     => 'asset_records.room_no',
        'date'     => 'asset_records.acqdate' },
      :rsort    => nil,                 # rsort is allowed according to rules in :sort (key as a flag)
      :patterns => { 
        :loc      => {
          :conditions => 'asset_records.sitename LIKE :loc OR asset_records.room_no LIKE :loc' 
        },
        :query    => {
          :conditions => 'asset_records.barcode LIKE :query OR asset_records.serialnum LIKE :query OR asset_records.make LIKE :query OR asset_records.model LIKE :query' 
        }
      }
    }
  end
  
  def create_asset_if_missing
    klass = nil
    tags = [ ]
    case item
    when /^Computer/
      klass = Computer
      tags << 'desktop'
    when /^Laptop/
      klass = Computer
      tags << 'laptop'
    when /^Server/
      klass = Computer
      tags << 'server'
    when /Printer/
      klass = Printer
      tags << 'printer'
    when /Scanner/
      klass = Printer
      tags << 'scanner'
    when /Switch/
      klass = NetDevice
    when /TSU/
      tags << 'router'
      klass = NetDevice
    else
    end
    if !klass.nil? && !Asset.find_by_barcode(barcode)
      site = case sitename.downcase
      when /^bacich / then 'Bacich'
      when /^kent / then 'Kent'
      when /^kentfield / then 'District'
      end
      location = [site, room_no].join(' ').strip
      attrs = { :barcode => barcode, 
        :serial_number => serialnum,
        :manufacturer  => make,
        :description   => model,
        :location      => location,
        :purchased     => acqdate }
      asset = klass.create(attrs)
      if tags.size
        tag_list = tags.join(', ')
        print "tagging asset with #{tag_list}\n"
        asset.tag_list = tag_list
        asset.save
      end
    end
  end
  
  class << self
    def primary_key
      :barcode
    end

    def import_csv(fname='asset_records.csv')
      fname = File.join(RAILS_ROOT, 'data/inventory', fname) unless fname[0] == '/'
      FasterCSV.foreach(fname, :col_sep => ',',
        :headers => true, :header_converters => :symbol) do |row|
        print "#{row[:barcode]}\n"
        attrs = row.to_hash
        if !Asset.valid_barcode? attrs[:barcode]
          print "bad barcode: #{attrs[:barcode]}\n"
          next
        end
        attrs.delete(:serialnum) unless Asset.valid_serial_number? attrs[:serialnum]
        ar = nil
        begin
          ar = AssetRecord.create(attrs)
        rescue
          print "asset record not created (duplicate barcode?)\n"
        end
        begin
          ar.create_asset_if_missing unless ar.nil?
        rescue
          print "associated asset not created\n"
          raise
        end
      end
    end
  end
end
