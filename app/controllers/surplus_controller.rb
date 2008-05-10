class SurplusController < ApplicationController
  def index
    @assets = Asset.find(:all, :conditions => ['status=?', 'surplus200803'], :order => 'item_class, manufacturer, description, serial_number')
  end
end
