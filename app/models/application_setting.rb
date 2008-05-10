class ApplicationSetting < ActiveRecord::Base
  belongs_to :inventory
  
  alias_method :current_inventory, :inventory
  alias_method :current_inventory=, :inventory=
end
