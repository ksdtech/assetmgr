class SurplusController < ApplicationController
  def index
    @assets = Asset.find(:all, :conditions => ['status=?', 'surplus-2008-09'], :order => 'item_class, manufacturer, description, serial_number')
  end
end
