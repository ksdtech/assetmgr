desc "Get printer page counts from SNMP"
task(:snmp_poll => :environment) do
  Printer.snmp_poll
end
