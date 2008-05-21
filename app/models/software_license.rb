class SoftwareLicense < ActiveRecord::Base
  include SearchableRecord

  class << self
    def per_page
      30 
    end
    
    def find_options(tag)
      tag.blank? ? { } : tagged_find_options
    end

    def tagged_find_options
      { :joins => "INNER JOIN taggings ON taggings.taggable_id=software_licenses.id INNER JOIN tags ON tags.id=taggings.tag_id",
        :conditions => "taggings.taggable_type='SoftwareLicense'" }
    end

    def search_rules
      {
        :query    => nil, # flag
        :page     => nil, # flag
        :offset   => nil, # flag
        :sort     => { 
          'id'        => 'software_licenses.id',
          'name'      => 'software_licenses.application',
          'vendor'    => 'software_licenses.publisher',
          'serial'    => 'software_licenses.serial_number',
          'version'   => 'software_licenses.version',
          'os'        => 'software_licenses.os',
          'use'       => 'software_licenses.use',
          'location'  => 'software_licenses.location' },
        :rsort    => nil,                 # rsort is allowed according to rules in :sort (key as a flag)
        :patterns => { 
          :tag      => {
            :conditions => 'tags.name LIKE :tag', :converter => lambda { |val| val } },
          :query    => {
            :conditions => 'software_licenses.application LIKE :query OR software_licenses.publisher LIKE :query OR software_licenses.serial_number LIKE :query OR software_licenses.version LIKE :query OR software_licenses.install_key LIKE :query OR software_licenses.location LIKE :query OR software_licenses.use LIKE :query OR software_licenses.notes LIKE :query' 
          }
        }
      }
    end
  end
end

