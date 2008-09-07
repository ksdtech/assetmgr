class NrConfigurationsController < ApplicationController
  # GET /nr_configurations
  # GET /nr_configurations.xml
  def index
    @nr_configurations = NrConfiguration.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nr_configurations }
    end
  end

  # GET /nr_configurations/1
  # GET /nr_configurations/1.xml
  def show
    @nr_configuration = NrConfiguration.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nr_configuration }
    end
  end

  # GET /nr_configurations/new
  # GET /nr_configurations/new.xml
  def new
    @nr_configuration = NrConfiguration.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nr_configuration }
    end
  end

  # GET /nr_configurations/1/edit
  def edit
    @nr_configuration = NrConfiguration.find(params[:id])
  end

  # POST /nr_configurations
  # POST /nr_configurations.xml
  def create
    @nr_configuration = NrConfiguration.new(params[:nr_configuration])

    respond_to do |format|
      if @nr_configuration.save
        flash[:notice] = 'NetRestore configuration was successfully created.'
        format.html { redirect_to(@nr_configuration) }
        format.xml  { render :xml => @nr_configuration, :status => :created, :location => @nr_configuration }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nr_configuration.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /nr_configurations/1
  # PUT /nr_configurations/1.xml
  def update
    @nr_configuration = NrConfiguration.find(params[:id])

    respond_to do |format|
      if @nr_configuration.update_attributes(params[:nr_configuration])
        flash[:notice] = 'NetRestore configuration was successfully updated.'
        format.html { redirect_to(@nr_configuration) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @nr_configuration.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /nr_configurations/1
  # DELETE /nr_configurations/1.xml
  def destroy
    @nr_configuration = NrConfiguration.find(params[:id])
    @nr_configuration.destroy

    respond_to do |format|
      format.html { redirect_to(nr_configurations_url) }
      format.xml  { head :ok }
    end
  end
end
