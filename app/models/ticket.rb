class Ticket < ActiveRecord::Base
  include SearchableRecord
  
  STATUS_OPTIONS   = ['', 'Not Started', 'In Progress', 'Completed', 'Deferred']
  PRIORITY_OPTIONS = ['', 'Low', 'Medium', 'High', 'Critical']
  COMPLETED = 3
  MEDIUM = 2
  
  belongs_to :asset
  belongs_to :requestor, :class_name => 'User'
  belongs_to :assignee,  :class_name => 'User'
  belongs_to :ticket_category
  has_many   :ticket_items, :order => :created_at
  has_many   :seen_tickets

  attr_accessor :asset_query, :asset_link
  attr_accessor :response, :units_spent, :time_spent
  attr_accessor :notify_requestor, :previous_assignee_id, :updater_id
  validates_presence_of :subject
  validates_presence_of :description
  validates_presence_of :requestor
  validates_presence_of :ticket_category
  validates_presence_of :status, :if => Proc.new { |t| t.administrator? }
  validates_presence_of :priority, :if => Proc.new { |t| t.administrator? }
  validates_presence_of :importance, :unless => Proc.new { |t| t.administrator? }
  before_save :check_asset_link
  after_save  :add_response_and_send_notifications
  
  def administrator?
    !self.updater_id.nil? && (u = User.find_by_id(self.updater_id)) && u.administrator?
  end
  
  def self_assigned?
    !self.updater_id.nil? && self.updater_id == self.assignee_id
  end
  
  def validate
    if status == COMPLETED && ticket_items.count == 0
      errors.add_on_empty('response') 
      errors.add_on_empty('time_spent')
    else
      errors.add_on_empty('time_spent') if !response.blank?
    end
  end
  
  def check_asset_link
    val = @asset_link.to_i
    if val != 0         # 0 means no change
      if val == -1      # -1 means remove link
        self[:asset_id] = nil
      elsif Asset.count(:conditions => ['id=?', val]) != 0
        self[:asset_id] = val
      end
    end
  end
  
  def add_response_and_send_notifications
    add_response
    send_notifications
  end
  
  def add_response
    if !@response.blank?
      minutes_spent = (@units_spent.nil? || @time_spent.nil?) ? 0 : @units_spent.to_i * @time_spent.to_i
      ticket_items << TicketItem.new(:response => @response, :minutes_spent => minutes_spent, :assignee_id => assignee_id)
    end
  end
  
  def send_notifications
    if status == COMPLETED && notify_requestor.to_i == 1 && !requestor_id.nil?
      u = User.find(requestor_id)
      if !u.nil? && !u.email_address.blank?
        TicketNotifier.deliver_notify_requestor_on_completion(u, self)
      end
    end
    
    if !assignee_id.nil? && assignee_id != @previous_assignee_id && !self_assigned?
      u = User.find(assignee_id)
      if !u.nil? && !u.email_address.blank?
        TicketNotifier.deliver_notify_assignee_on_assignment(u, self)
      end
    end
  end
  
  def subject_with_asset(show_asset=true)
    return (!asset.nil? && show_asset) ? "#{asset.title} - #{subject}" : subject
  end
      
  def assignee_to_s
    assignee.nil? ? '' : assignee.last_first
  end
    
  def requestor_to_s
    requestor.nil? ? '' : requestor.last_first
  end

  def category_to_s
    ticket_category.nil? ? '' : ticket_category.name
  end

  def priority_to_s
    priority.nil? ? '' : PRIORITY_OPTIONS[priority]
  end
    
  def importance_to_s
    importance.nil? ? '' : PRIORITY_OPTIONS[importance]
  end
  
  def requestor_name
    u = requestor_id.nil? ? nil: User.find(requestor_id)
    u.nil? ? 'Unknown' : u.full_name
  end
    
  def total_minutes_spent
    ticket_items.sum(:minutes_spent) || 0
  end
  
  def total_time_to_s
    t = total_minutes_spent
    return "#{t} minutes" if t < 60
    t = t.to_f / 60.0
    sprintf('%.2f hours', t)
  end
    
  def completion_response
    last_item = ticket_items.find(:first, :order => 'created_at DESC')
    last_item.nil? ? nil : last_item.response
  end
    
  class << self
    def options_for_priority(blank=nil, bval=0)
      if !@priority_opts
        @priority_opts = []
        PRIORITY_OPTIONS.each_with_index { |opt, i| @priority_opts << [ opt, i ] if i != 0 }
      end
      blank.nil? ? @priority_opts : ([ [ blank, bval ] ] + @priority_opts)
      @priority_opts
    end

    def options_for_status(blank=nil, bval=0)
      if !@status_opts
        @status_opts = []
        STATUS_OPTIONS.each_with_index { |opt, i| @status_opts << [ opt, i ] if i != 0 }
      end
      blank.nil? ? @status_opts : ([ [ blank, bval ] ] + @status_opts)
    end
    
    def per_page
      30 
    end

    def find_options
      { :joins => "LEFT OUTER JOIN assets ON assets.id=tickets.asset_id LEFT OUTER JOIN ticket_items ON ticket_items.ticket_id=tickets.id" }
    end

    def search_rules
      {
        :query    => nil, # flag
        :page     => nil, # flag
        :offset   => nil, # flag
        :sort     => { 
          'id'        => 'tickets.id',
          'asset'     => 'assets.name',
          'requestor' => 'tickets.requestor_id',
          'assignee'  => 'tickets.assignee_id',
          'adate'     => 'tickets.date_assigned',
          'ddate'     => 'tickets.date_due' },
        :rsort    => nil,                 # rsort is allowed according to rules in :sort (key as a flag)
        :patterns => { 
          :status    => 'tickets.status',
          :requestor => 'tickets.requestor_id',
          :assignee  => 'tickets.assignee_id',
          :query     => {
            :conditions => 'assets.name LIKE :query OR assets.barcode LIKE :query OR assets.serial_number LIKE :query OR tickets.subject LIKE :query OR tickets.description LIKE :query OR tickets.case_number LIKE :query OR tickets.dispatch_number LIKE :query OR ticket_items.response LIKE :query' 
          }
        }
      }
    end    
  end
end
