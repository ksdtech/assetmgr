class OthersController < AssetController
  
  # before_filter
  def set_classes
    @asset_class = OtherAsset
    @coll_name = :others
    @memb_name = :other
    super
  end
  
  # GET /others
  # GET /others.xml
  def index
    @content_title = @title = 'Search for other assets'
    @asset_params = params.dup
    @assets = OtherAsset.paginated_collection(Asset.per_page, params, Asset.search_rules, Asset.find_options)
    asset_index
  end
  
  # GET /others/1
  # GET /others/1.xml
  def show
    @asset = OtherAsset.find(params[:id])
    @content_title = @title = "Editing #{@asset.title}"
    @submit_value = "Update"
    asset_show
  end
  
  # GET /others/new
  def new
    @asset = OtherAsset.new
    @content_title = @title = "Editing new asset"
    @submit_value = "Create"
  end

  # GET /others/1;edit
  def edit
    @asset = OtherAsset.find(params[:id])
    @content_title = @title = "Editing #{@asset.title}"
    @submit_value = "Update"
  end

  # POST /others
  # POST /others.xml
  def create
    @asset = OtherAsset.new(params[:asset])
    asset_create('other', others_url)
  end

  # PUT /others/1
  # PUT /others/1.xml
  def update
    @asset = OtherAsset.find(params[:id])
    asset_update(params[:asset], others_url)
  end

  # DELETE /others/1
  # DELETE /others/1.xml
  def destroy
    @asset = OtherAsset.find(params[:id])
    asset_destroy(others_url)
  end
  
end
