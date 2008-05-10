class Ether < ActiveRecord::Base
  MEDIA_TYPE_OPTIONS = [ '', 'cat5', 'wireless', 'fiber', 'other' ]
  
  belongs_to :asset

end
