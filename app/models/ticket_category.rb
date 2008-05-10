class TicketCategory < ActiveRecord::Base
  has_many :tickets
  
  class << self
    def import_categories(fname = 'categories.txt')
      fname = File.join(RAILS_ROOT, 'data', fname) unless fname[0, 1] == '/'
      FasterCSV.foreach(fname, :headers => false, :col_sep => "\t", :row_sep => "\n") do |row|
        TicketCategory.create(:name => row[0].strip) if !row[0].blank?
      end
    end
  end
end
