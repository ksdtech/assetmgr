class NrConfiguration < ActiveRecord::Base
  has_many :machine_groups
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :protocol
  validates_presence_of :path  
  
  PROTOCOL_OPTIONS = [ 
    ['AFP', 'afp'],
    ['HTTP', 'http'],
    ['NFS', 'nfs'],
    ['Multicast ASR', 'asr'],
    ['Local', 'local'] ]

    def self.content_columns
      @content_columns ||= columns.reject { |c| c.primary || c.name =~ /(_id|_count|_at|username|password)$/ || c.name == inheritance_column }
    end  
end
