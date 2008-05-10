class User < ActiveRecord::Base
  belongs_to :site
  has_many   :seen_tickets
  has_many   :requested_tickets, :class_name => 'Ticket', :foreign_key => :requestor_id
  has_many   :assigned_tickets,  :class_name => 'Ticket', :foreign_key => :assignee_id
  has_many   :ticket_items

  def full_name
    "#{first_name} #{last_name}".strip
  end
  
  def last_first
    "#{last_name}, #{first_name}".strip
  end
  
  class << self
    def authenticate(username, password)
      return nil if username.blank? || password.blank?
      u = User.find(:first, :conditions => ['login LIKE ? OR email_address LIKE ?', username, username])
      # password validation
      u 
    end
    
    def options_for_assignee(blank=nil, bval=0)
      opts = User.find(:all, :conditions => ['accepts_assignments=1'], :order => 'last_name, first_name').collect {|u| [ u.last_first, u.id ] }
      blank.nil? ? opts : ([ [ blank, bval ] ] + opts)
    end

    def options_for_requestor(blank=nil, bval=0)
      opts = User.find(:all, :order => 'last_name, first_name').collect {|u| [ u.last_first, u.id ] }
      blank.nil? ? opts : ([ [ blank, bval ] ] + opts)
    end
    
    def import_users(fname = 'teachers.txt')
      fname = File.join(RAILS_ROOT, 'data', fname) unless fname[0, 1] == '/'
      FasterCSV.foreach(fname, :headers => true, :header_converters => :symbol, :col_sep => "\t", :row_sep => "\n") do |row|
        uid = row[:teachernumber].to_i - 100000
        site_id = 100 + (uid / 1000).floor
        
        u = User.new(:site_id => site_id, 
          :first_name => row[:first_name], :last_name => row[:last_name],
          :telephone => row[:home_phone], :email_address => row[:email_addr], 
          :login => row[:network_id], :password => row[:network_password],
          :administrator => false)
        u.id = uid
        begin
          u.save
        rescue
        end
      end
    end
  end
end
