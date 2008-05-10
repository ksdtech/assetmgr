class ComputerListMember < ActiveRecord::Base
  belongs_to :computer_list
  belongs_to :computer, :foreign_key => :asset_id
  
end
