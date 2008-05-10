MACHINE_GROUPS = [
  ['Kent Library', 1],
  ['Kent Labs', 2],
  ['Kent Office', 3],
  ['Kent Classrooms', 4],
  ['Kent Teacher Laptops', 5],
  ['Kent Student Laptops', 6],
  ['Kent Resource', 7],
  ['Bacich Library', 8],
  ['Bacich Labs', 9],
  ['Bacich Office', 10],
  ['Bacich Classrooms', 11],
  ['Bacich Teacher Laptops', 12],
  ['Bacich Student Laptops', 13],
  ['Bacich Resource', 14]
]

class CreateMachineGroups < ActiveRecord::Migration
  def self.up
    create_table :nr_machine_groups, :force => true do |t|
      t.column :name,                :string,      :limit => 128, :default => "", :null => false
      t.column :admin_group_id,      :integer,     :default => 1,  :null => false
      t.column :nr_configuration_id, :integer,     :default => 1,  :null => false
      t.column :nr_parameter_id,     :integer,     :default => 1,  :null => false
    end
    
    MACHINE_GROUPS.each do |mg|
      MachineGroup.create(:name => mg[0])
    end
  end

  def self.down
    drop_table :nr_machine_groups
  end
end
