class DeploystudioController < ApplicationController
  def index
    loc = params[:loc]
    conds = if loc
      [ "mac_address<>'' AND machine_group_id IS NOT NULL AND status=? AND location_site LIKE ?", 'active', "#{loc}\%" ]
    else
      [ "mac_address<>'' AND machine_group_id IS NOT NULL AND status=?", 'active' ]
    end
    @hosts = Computer.find(:all, :conditions => conds, :order => 'mac_address')
    render :action => 'index', :layout => 'blank'
  end
end
