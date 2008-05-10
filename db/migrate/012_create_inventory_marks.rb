class CreateInventoryMarks < ActiveRecord::Migration
  def self.up
    create_table :inventory_marks, :force => true do |t|
      t.column :inventory_id, :integer
      t.column :asset_id, :integer
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :inventory_marks
  end
end
