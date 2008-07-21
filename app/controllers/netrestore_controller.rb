class NetrestoreController < ActionController::Base
  
  # GET /netrestore?hw=<mac_address>&gp=<group_name>&p=<password>
  def index
    hw = Asset.format_mac_address(params[:hw])
    gp = params[:gp]
    passwd = params[:p]
    if hw.blank?
      @error = "Machine id parameter missing"
      render :action => 'index'
      return
    end
    if gp.blank? || passwd.blank?
      @error = "Group or password parameter missing"
      render :action => 'index'
      return
    end
    if gp != APP_CONFIG[:nr_group] || passwd != APP_CONFIG[:nr_password]
      render :action => 'denied.rxml', :layout => 'blank'
      return
    end
    computer = Computer.find(:first, :conditions => ['mac_address=?', hw])
    if !computer.nil?
      @nr_machine_settings = computer.nr_machine_settings
      @nr_parameter = computer.nr_parameter
      @nr_configuration = computer.nr_configuration
      @all_nr_configurations = NrConfiguration.find(:all, :order => 'name')
      @nr_tools = [ ]
      render :action => 'show.rxml', :layout => 'blank'
    else
      @error = "Machine id #{hw} not found"
      render :action => 'index'
    end
  end
  
end
