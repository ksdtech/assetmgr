class ComputerList < ActiveRecord::Base
  has_many :computer_list_members, :dependent => :delete_all
  has_many :assets, :through => :computer_list_members
  
  class << self
    def primary_key
      :ard_list_tag
    end
  end
end
