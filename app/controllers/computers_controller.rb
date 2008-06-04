class ComputersController < AssetController
  
  def action
    selected = []
    (params[:checked] || {}).each do |k, v|
      selected.push(k[1..k.length].to_i)
    end
    if selected.empty?
      flash[:notice] = 'No computers selected'
      redirect_to :action => 'index'
    else
      if params[:add_to_group]
        machine_group_id = (params[:machine_group] || 0).to_i
        if machine_group_id == 0
          flash[:notice] = "No group selected"
          redirect_to :action => 'index'
        else
          mg = MachineGroup.find(machine_group_id)
          added = 0
          found = 0
          selected.each do |cid|
            begin
              mg.computers.find(cid)
              found += 1
            rescue
              mg.computers << Computer.find(cid)
              added += 1
            end
          end
          flash[:notice] = "#{added} computers added, #{found} computers already in list"
          redirect_to :action => 'index'
        end
      else
        flash[:notice] = 'No action recognized'
        redirect_to :action => 'index'
      end
    end
  end
  
  # before_filter
  def set_classes
    @asset_class = Computer
    @coll_name = :computers
    @memb_name = :computer
    super
  end

  # GET /computers
  # GET /computers.xml
  def index
    @content_title = @title = 'Search for Computers'
    @asset_params = params.delete_if { |k, v| k == :commit }
    respond_to do |format|
      format.html do
        @assets = Computer.paginated_collection(Asset.per_page, params, Asset.search_rules, Asset.find_options(params[:tag]))
        asset_index
      end
      format.text do
        @assets = Computer.find_queried(:all, params, Asset.search_rules, Asset.find_options(params[:tag]))
        asset_index
      end
    end
  end

  # GET /computers/1
  # GET /computers/1.xml
  def show
    @asset = Computer.find(params[:id])
    @content_title = @title = "Editing #{@asset.title}"
    @submit_value = "Update"
    asset_show
  end

  # GET /computers/new
  def new
    @asset = Computer.new(:manufacturer => 'Apple', :status => 'inactive', :tag_list => 'new')
    @content_title = @title = "Editing new computer"
    @submit_value = "Create"
  end

  # GET /computers/1;edit
  def edit
    @asset = Computer.find(params[:id])
    @content_title = @title = "Editing #{@asset.title}"
    @submit_value = "Update"
  end

  # POST /computers
  # POST /computers.xml
  def create
    ethers, new_ethers = process_ethers(params[:asset])
    @asset = Computer.new(params[:asset])
    asset_create('computer', computers_url, ethers, new_ethers)
  end

  # PUT /computers/1
  # PUT /computers/1.xml
  def update
    ethers, new_ethers = process_ethers(params[:asset])
    post_save = params[:commit].match(/ARD/) ? :update_from_ard : nil
    @asset = Computer.find(params[:id])
    asset_update(params[:asset], computers_url, ethers, new_ethers, post_save)
  end

  # POST /computers/1;update_from_ard
  def update_from_ard
    @asset = Computer.find(params[:id])
    if @asset.update_from_ard
      flash[:notice] = 'Successfully updated from ARD data'
    else
      flash[:error] = 'Could not update from ARD data'
    end
    redirect_to edit_computer_path(@asset)
  end

  # DELETE /computers/1
  # DELETE /computers/1.xml
  def destroy
    @asset = Computer.find(params[:id])
    asset_destroy(computers_url)
  end
  
end
