class PrintersController < AssetController
  
  # before_filter
  def set_classes
    @asset_class = Printer
    @coll_name = :printers
    @memb_name = :printer
    super
  end
  
  # GET /printers
  # GET /printers.xml
  def index
    @content_title = @title = 'Search for Printers'
    @asset_params = params.dup
    respond_to do |format|
      format.html do 
        @assets = Printer.paginated_collection(Asset.per_page, params, Asset.search_rules, Asset.find_options(params[:tag]))
        render :template => 'assets/index.rhtml'
      end
      format.text do 
        @assets = Printer.find_queried(:all, params, Asset.search_rules, Asset.find_options(params[:tag]))
        render :template => 'assets/index.text.erb'
      end
    end
  end

  # GET /printers/1
  # GET /printers/1.xml
  def show
    @asset = Printer.find(params[:id])
    @content_title = @title = "Editing #{@asset.title}"
    @submit_value = "Update"
    asset_show
  end

  # GET /printers/new
  def new
   @asset = Printer.new
   @content_title = @title = "Editing new printer"
   @submit_value = "Create"
  end

  # GET /printers/1;edit
  def edit
    @asset = Printer.find(params[:id])
    @content_title = @title = "Editing #{@asset.title}"
    @submit_value = "Update"
  end

  # POST /printers
  # POST /printers.xml
  def create
    @asset = Printer.new(params[:asset])
    asset_create('printer', printers_url)
  end

  # PUT /printers/1
  # PUT /printers/1.xml
  def update
    @asset = Printer.find(params[:id])
    asset_update(params[:asset], printers_url)
  end

  # DELETE /printers/1
  # DELETE /printers/1.xml
  def destroy
    @asset = Printer.find(params[:id])
    asset_destroy(printers_url)
  end
  
end
