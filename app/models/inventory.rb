class Inventory < ActiveRecord::Base
  has_many :inventory_marks, :dependent => :delete_all
  has_many :assets, :through => :inventory_marks
  
end
