class CreateSeenTickets < ActiveRecord::Migration
  def self.up
    create_table :seen_tickets do |t|
      t.integer :user_id
      t.integer :ticket_id
      t.timestamps
    end
  end

  def self.down
    drop_table :seen_tickets
  end
end
