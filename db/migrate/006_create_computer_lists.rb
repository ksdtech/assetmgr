class CreateComputerLists < ActiveRecord::Migration
  def self.up
    create_table :computer_lists, :id => false, :force => true do |t|
      t.column :ard_list_tag, :string
      t.column :name, :string
    end
    add_index :computer_lists, :ard_list_tag, :unique => true
  end

  def self.down
    drop_table :computer_lists
  end
end
