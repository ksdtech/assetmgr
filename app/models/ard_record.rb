class ArdRecord < ActiveRecord::Base

  class << self
    def primary_key
      :mac_address
    end
  end
end
