class NetworkController < AssetController
  
  # before_filter
  def set_classes
    @asset_class = NetDevice
    @coll_name = :network
    @memb_name = :network_item
    super
  end
  
  # GET /network
  # GET /network.xml
  def index
    @content_title = @title = 'Search for Network Devices'
    @asset_params = params.dup
    respond_to do |format|
      format.html do 
        @assets = NetDevice.paginated_collection(Asset.per_page, params, Asset.search_rules, Asset.find_options(params[:tag]))
        render :template => 'assets/index.rhtml'
      end
      format.text do 
        @assets = NetDevice.find_queried(:all, params, Asset.search_rules, Asset.find_options(params[:tag]))
        render :template => 'assets/index.text.erb'
      end
    end
  end

  # GET /network/1
  # GET /network/1.xml
  def show
    @asset = NetDevice.find(params[:id])
    @content_title = @title = "Editing #{@asset.title}"
    @submit_value = "Update"
    asset_show
  end

  # GET /network/new
  def new
    @asset = NetDevice.new
    @content_title = @title = "Editing new network device"
    @submit_value = "Create"
  end

  # GET /network/1;edit
  def edit
    @asset = NetDevice.find(params[:id])
    @content_title = @title = "Editing #{@asset.title}"
    @submit_value = "Update"
  end

  # POST /network
  # POST /network.xml
  def create
    ethers, new_ethers = process_ethers(params[:asset])
    @asset = NetDevice.new(params[:asset])
    asset_create('network_item', network_url, ethers, new_ethers)
  end

  # PUT /network/1
  # PUT /network/1.xml
  def update
    ethers, new_ethers = process_ethers(params[:asset])
    @asset = NetDevice.find(params[:id])
    asset_update(params[:asset], network_url, ethers, new_ethers)
  end

  # DELETE /network/1
  # DELETE /network/1.xml
  def destroy
    @asset = NetDevice.find(params[:id])
    asset_destroy(network_url)
  end
  
end
