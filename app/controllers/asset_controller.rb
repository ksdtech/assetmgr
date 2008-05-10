
class AssetController < ApplicationController
  before_filter :set_classes
  ACTIVE_PARAMS = [:query, :loc, :status]
  
  protected
  
  def set_classes
    @current_inventory = Asset.current_inventory
  end
      
  def asset_index
    respond_to do |format|
      format.html { render :template => 'assets/index.rhtml' }
      format.xml  { render :xml => @assets.to_xml }
      format.js   { render :template => 'assets/index.rjs' }
    end
  end

  def asset_show
    respond_to do |format|
      format.html { render :action => 'edit' }
      format.xml  { render :xml => @asset.to_xml }
    end
  end

  def asset_create(memb_route, coll_url, ethers=nil, new_ethers=nil)
    respond_to do |format|
      if @asset.save
        flash[:notice] = "#{@asset.title} was successfully created."
        @asset.save_ethers(ethers, new_ethers)
        format.html { redirect_to coll_url }
        format.xml  { head :created, :location => send("#{memb_route}_url", @asset) }
      else
        @content_title = @title = "Editing new asset"
        @submit_value = "Create"
        format.html { render :action => 'new' }
        format.xml  { render :xml => @asset.errors.to_xml }
      end
    end
  end

  def asset_update(attrs, coll_url, ethers=nil, new_ethers=nil, post_save=nil)
    respond_to do |format|
      if @asset.update_attributes(attrs)
        flash[:notice] = "#{@asset.title} was successfully updated."
        @asset.save_ethers(ethers, new_ethers)
        if !post_save.blank?
          result, msg = @asset.send(post_save)
          flash[:notice] << "  #{msg}" if !msg.blank?
        end
        format.html { redirect_to coll_url }
        format.xml  { head :ok }
      else
        @content_title = @title = "Editing #{@asset.title}"
        @submit_value = "Update"
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @asset.errors.to_xml }
      end
    end
  end
  
  def asset_destroy(coll_url)
    title = @asset.title
    @asset.destroy
    respond_to do |format|
      flash[:notice] = "#{title} was successfully deleted."
      format.html { redirect_to coll_url }
      format.xml  { head :ok }
    end
  end
  
  def process_ethers(params)
    ethers = params.delete(:ether)
    new_ethers = params.delete(:new_ether)
    [ ethers, new_ethers ]
  end
    
end
