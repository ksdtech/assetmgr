class NrParameter < ActiveRecord::Base
  has_many :machine_groups
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def self.content_columns
    @content_columns ||= columns.reject { |c| c.primary || c.name =~ /(_id|_count|_at|username|password)$/ || c.name == inheritance_column }
  end
end
