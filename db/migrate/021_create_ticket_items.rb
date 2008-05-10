class CreateTicketItems < ActiveRecord::Migration
  def self.up
    create_table :ticket_items, :force => true do |t|
      t.integer :ticket_id
      t.integer :assignee_id
      t.text    :response
      t.integer :minutes_spent, :null => false, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :ticket_items
  end
end
