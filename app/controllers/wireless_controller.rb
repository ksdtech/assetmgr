class WirelessController < AssetController
  
  # before_filter
  def set_classes
    @asset_class = WirelessDevice
    @coll_name = :wireless
    @memb_name = :wireless_item
    super
  end
  
  # GET /wireless
  # GET /wireless.xml
  def index
    @content_title = @title = 'Search for Wireless Devices'
    @asset_params = params.dup
    @assets = WirelessDevice.paginated_collection(Asset.per_page, params, Asset.search_rules, Asset.find_options)
    asset_index
  end

  # GET /wireless/1
  # GET /wireless/1.xml
  def show
    @asset = WirelessDevice.find(params[:id])
    @content_title = @title = "Editing #{@asset.title}"
    @submit_value = "Update"
    asset_show
  end

  # GET /wireless/new
  def new
    @asset = WirelessDevice.new
    @content_title = @title = "Editing new wireless device"
    @submit_value = "Create"
  end

  # GET /wireless/1;edit
  def edit
    @asset = WirelessDevice.find(params[:id])
    @content_title = @title = "Editing #{@asset.title}"
    @submit_value = "Update"
  end

  # POST /wireless
  # POST /wireless.xml
  def create
    ethers, new_ethers = process_ethers(params[:asset])
    @asset = WirelessDevice.new(params[:asset])
    asset_create('wireless_item', wireless_url, ethers, new_ethers)
  end

  # PUT /wireless/1
  # PUT /wireless/1.xml
  def update
    ethers, new_ethers = process_ethers(params[:asset])
    @asset = WirelessDevice.find(params[:id])
    asset_update(params[:asset], wireless_url, ethers, new_ethers)
  end

  # DELETE /wireless/1
  # DELETE /wireless/1.xml
  def destroy
    @asset = WirelessDevice.find(params[:id])
    asset_destroy(wireless_url)
  end
  
end
