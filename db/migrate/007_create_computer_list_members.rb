class CreateComputerListMembers < ActiveRecord::Migration
  def self.up
    create_table :computer_list_members do |t|
      t.column :computer_id, :integer
      t.column :computer_list_id, :string
    end
  end

  def self.down
    drop_table :computer_list_members
  end
end
