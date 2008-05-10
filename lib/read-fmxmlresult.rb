#!/usr/bin/env ruby

# code to read the FMXMLRESULT data exported from FileMaker versions 6 
# and later.

require 'rubygems'
require 'hpricot'
require 'yaml'

sql_types = { 'TEXT' => 'string', 'NUMBER' => 'integer', 'DATE' => 'date' }

# print out schema for ruby on rails migration
print "create_table :software_licenses, :force => true do |t|\n"
doc = Hpricot.XML(open(File.join(File.dirname(__FILE__), '../db/software.xml')))
fields = [ ]
doc.search(:metadata)[0].search(:field).each do |f|
  name = f[:name].downcase.gsub(/[^a-z0-9]+/, '_')
  sql_type = sql_types[f[:type]]
  print "  t.column :#{name}, :#{sql_type}\n"
  fields.push({:name => name, :type => sql_type})
end
print "end\n"

# print out yaml-encoded data file
data = { }
rows = doc.search(:resultset)[0].search(:row).each do |row|
  i = 0
  recid = row[:recordid]
  data_row = { }
  row.search(:col).each do |col| 
    key = fields[i][:name]
    val = col.search(:data)[0].innerHTML
    sql_type = fields[i][:type]
    case sql_type
    when 'integer'
      val = val.to_i
    when 'date'
      m, d, y = val.split(/\//)
      val = y ? Date.civil(y.to_i, m.to_i, d.to_i) : nil
    else
      val = val.gsub(/[\r\n]/, '. ')
    end
    data_row[key] = val
    i += 1
  end
  data["rec_#{recid}"] = data_row
end
print data.to_yaml


  