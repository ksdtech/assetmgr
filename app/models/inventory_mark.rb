class InventoryMark < ActiveRecord::Base
  belongs_to :inventory
  belongs_to :asset
end
