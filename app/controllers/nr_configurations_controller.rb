class NrConfigurationsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @nr_configuration_pages, @nr_configurations = paginate :nr_configurations, :per_page => 10
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
      redirect_to :action => 'list'
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
      redirect_to :action => 'show', :id => @nr_configuration
    else
      render :action => 'edit'
    end
  end

  def destroy
    NrConfiguration.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end