class LicensesController < ApplicationController
  # GET /licenses
  # GET /licenses.xml
  def index
    @content_title = @title = 'Search for Software Licenses'
    @licenses = WillPaginate::Collection.create(params[:page] || 1, 20, SoftwareLicense.count()) do |pager|
      pager.replace(SoftwareLicense.find(:all, { :order => 'application, version', :offset => pager.offset, :limit => pager.per_page }))
    end
  end

  # GET /licenses/1
  # GET /licenses/1.xml
  def show
    @license = SoftwareLicense.find(params[:id])
    @content_title = @title = "Editing license"
    @submit_value = "Update"
  end

  # GET /licenses/new
  def new
   @license = SoftwareLicense.new
   @content_title = @title = "Editing new license"
   @submit_value = "Create"
  end

  # GET /licenses/1;edit
  def edit
    @license = SoftwareLicense.find(params[:id])
    @content_title = @title = "Editing license"
    @submit_value = "Update"
  end

  # POST /licenses
  # POST /licenses.xml
  def create
    @license = SoftwareLicense.new(params[:license])
    
    respond_to do |format|
      if @license.save 
        flash[:notice] = 'License was successfully created.'
        format.html { redirect_to licenses_url }
        format.xml  { head :created, :location => license_url(@license) }
      else
        @content_title = @title = "Editing new license"
        @submit_value = 'Create'
        format.html { render :action => "new" }
        format.xml  { render :xml => @license.errors.to_xml }
      end
    end
  end

  # PUT /licenses/1
  # PUT /licenses/1.xml
  def update
    @license = SoftwareLicense.find(params[:id])
    
    respond_to do |format|
      if @license.update_attributes(params[:license])
        flash[:notice] = 'Ticket was successfully updated.'
        format.html { redirect_to licenses_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @license.errors.to_xml }
      end
    end
  end

  # DELETE /licenses/1
  # DELETE /licenses/1.xml
  def destroy
    @license = SoftwareLicense.find(params[:id])
  end
end
