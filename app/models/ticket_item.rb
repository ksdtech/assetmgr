class TicketItem < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :assignee, :class_name => 'User'
  
  validates_presence_of :assignee_id
  validates_presence_of :response
  validates_numericality_of :minutes_spent, :only_integer => true, :greater_than => 0
end
