class MachineGroup < ActiveRecord::Base
  set_table_name :nr_machine_groups
  has_many :computers
  belongs_to :nr_configuration
  belongs_to :nr_parameter
  
  def export_nr_csv
    Computer.export_nr_csv(computers, "#{name.downcase.gsub(/\s+/, '-')}.csv")
  end
end
