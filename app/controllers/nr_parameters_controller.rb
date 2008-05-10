class NrParametersController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @nr_parameter_pages, @nr_parameters = paginate :nr_parameters, :per_page => 10
  end

  def show
    @nr_parameter = NrParameter.find(params[:id])
  end

  def new
    @nr_parameter = NrParameter.new
  end

  def create
    @nr_parameter = NrParameter.new(params[:nr_parameter])
    if @nr_parameter.save
      flash[:notice] = 'NetRestore settings were successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @nr_parameter = NrParameter.find(params[:id])
  end

  def update
    @nr_parameter = NrParameter.find(params[:id])
    if @nr_parameter.update_attributes(params[:nr_parameter])
      flash[:notice] = 'NetRestore settings were successfully updated.'
      redirect_to :action => 'show', :id => @nr_parameter
    else
      render :action => 'edit'
    end
  end

  def destroy
    NrParameter.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
