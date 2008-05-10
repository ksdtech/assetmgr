class CreateInventories < ActiveRecord::Migration
  def self.up
    create_table :inventories, :force => true do |t|
      t.column :name, :string
      t.column :purpose, :string
      t.column :start_date, :date
      t.column :end_date, :date
    end
  end

  def self.down
    drop_table :inventories
  end
end
