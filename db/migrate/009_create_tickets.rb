class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.integer  :asset_id
      t.integer  :requestor_id
      t.integer  :assignee_id
      t.integer  :ticket_category_id
      t.string   :subject
      t.integer  :priority
      t.integer  :importance, :null => false, :default => 2
      t.text     :description
      t.integer  :page_count
      t.integer  :cycle_count
      t.datetime :date_assigned
      t.datetime :date_due
      t.datetime :date_completed
      t.datetime :estimated_start_date
      t.datetime :estimated_completion_date
      t.string   :case_number
      t.string   :dispatch_number
      t.integer  :status
      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
