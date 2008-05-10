class InventoryController < ApplicationController
  
  # GET /inventory
  # GET /inventory.xml
  def index
    @content_title = @title = 'Inventory List'
    @assets = AssetRecord.paginated_collection(AssetRecord.per_page, params, AssetRecord.search_rules)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @assets.to_xml }
      format.js   # index.rjs
    end
  end

  # GET /inventory/1
  # GET /inventory/1.xml
  def show
    @asset = AssetRecord.find(params[:id])
    @content_title = @title = "Information for #{@asset.barcode}"
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @asset.to_xml }
    end
  end
  protected
  
  def sort_order(sort_params)
    sort = case sort_params  
      when /^serial/   then 'serialnum ASC'
      when /^make/    then 'make ASC'
      when /^model/    then 'model ASC'
      when /^site/ then 'sitename ASC'
      when /^room/ then 'room_no ASC'
      when /^date/ then 'acqdate ASC'
      else
        # /^barcode/
        'barcode ASC'
      end
    sort.gsub!(/ ASC/, ' DESC') if !sort_params.blank? && sort_params.match(/_r/)
    return sort
  end
end
