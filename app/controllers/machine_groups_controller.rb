class MachineGroupsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @machine_groups = WillPaginate::Collection.create(params[:page] || 1, 20, MachineGroup.count()) do |pager|
      pager.replace(MachineGroup.find(:all, { :order => :name, :offset => pager.offset, :limit => pager.per_page }))
    end
  end

  def show
    @machine_group = MachineGroup.find(params[:id])
    @nr_configuration = @machine_group.nr_configuration
    @nr_parameter = @machine_group.nr_parameter
  end

  def new
    @machine_group = MachineGroup.new
  end

  def create
    @machine_group = MachineGroup.new(params[:machine_group])
    if @machine_group.save
      flash[:notice] = 'Machine group was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @machine_group = MachineGroup.find(params[:id])
  end

  def update
    @machine_group = MachineGroup.find(params[:id])
    selected = []
    (params[:remove] || {}).each do |k, v|
      selected.push(k[1..k.length].to_i)
    end
    if @machine_group.update_attributes(params[:machine_group])
      removed = 0
      removal_errors = [ ]
      selected.each do |cid|
        begin
          @machine_group.computers.delete(Computer.find(cid))
          removed += 1
        rescue
          removal_errors << "Error removing #{cid}: #{$!}"
        end
      end
      msg = 'Machine group was successfully updated.'
      if removed > 0
        msg += " #{removed} computers were removed from group."
      end
      if !removal_errors.empty?
        msg += removal_errors.join(' ')
      end
      flash[:notice] = msg
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    MachineGroup.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
