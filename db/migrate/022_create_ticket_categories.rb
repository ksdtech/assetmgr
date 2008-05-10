class CreateTicketCategories < ActiveRecord::Migration
  def self.up
    create_table :ticket_categories, :force => true do |t|
      t.string :name
      t.timestamps
    end
    
    TicketCategory.import_categories
  end

  def self.down
    drop_table :ticket_categories
  end
end
