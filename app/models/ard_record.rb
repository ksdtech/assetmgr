class ArdRecord  < ActiveRecord::Base
  
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
  
  def model_and_class
    "#{MAC_MODELS.fetch(self.machine_model, self.machine_model)} - #{self.machine_class}"
  end
  
  class << self
    def update
      ArdSystemInfo.all_computerids.each do |cid|
        attrs = ArdSystemInfo.system_attributes(cid, true)
        p attrs
        ar = ArdRecord.find(:first, :conditions => ['computerid=?', cid])
        if ar.nil?
          ar = ArdRecord.create(attrs)
        else
          ar.update_attributes(attrs)
        end
      end
    end
  end
end

