class SurplusController < ApplicationController
  def index
    @assets = Asset.find(:all, :conditions => ['status=?', 'surplus200809'], :order => 'item_class, manufacturer, description, serial_number')
  end
end
