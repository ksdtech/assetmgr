class NrConfigurationsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => nr_configurations_url

  def list
    @nr_configurations = NrConfiguration.paginate :per_page => 10, :page => (params[:page] || 1)
  end

  def show
    @nr_configuration = NrConfiguration.find(params[:id])
  end

  def new
    @nr_configuration = NrConfiguration.new
  end

  def create
    @nr_configuration = NrConfiguration.new(params[:nr_configuration])
    if @nr_configuration.save
      flash[:notice] = 'NetRestore configuration was successfully created.'
      redirect_to nr_configurations_url
    else
      render :action => 'new'
    end
  end

  def edit
    @nr_configuration = NrConfiguration.find(params[:id])
  end

  def update
    @nr_configuration = NrConfiguration.find(params[:id])
    if @nr_configuration.update_attributes(params[:nr_configuration])
      flash[:notice] = 'NetRestore configuration was successfully updated.'
      redirect_to nr_configuration_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    NrConfiguration.find(params[:id]).destroy
    redirect_to nr_configurations_url
  end
end
