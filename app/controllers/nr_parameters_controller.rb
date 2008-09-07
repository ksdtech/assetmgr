class NrParametersController < ApplicationController
  # GET /nr_parameters
  # GET /nr_parameters.xml
  def index
    @nr_parameters = NrParameter.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nr_parameters }
    end
  end

  # GET /nr_parameters/1
  # GET /nr_parameters/1.xml
  def show
    @nr_parameter = NrParameter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nr_parameter }
    end
  end

  # GET /nr_parameters/new
  # GET /nr_parameters/new.xml
  def new
    @nr_parameter = NrParameter.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nr_parameter }
    end
  end

  # GET /nr_parameters/1/edit
  def edit
    @nr_parameter = NrParameter.find(params[:id])
  end

  # POST /nr_parameters
  # POST /nr_parameters.xml
  def create
    @nr_parameter = NrParameter.new(params[:nr_parameter])

    respond_to do |format|
      if @nr_parameter.save
        flash[:notice] = 'NetRestore parameter was successfully created.'
        format.html { redirect_to(@nr_parameter) }
        format.xml  { render :xml => @nr_parameter, :status => :created, :location => @nr_parameter }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nr_parameter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /nr_parameters/1
  # PUT /nr_parameters/1.xml
  def update
    @nr_parameter = NrParameter.find(params[:id])

    respond_to do |format|
      if @nr_parameter.update_attributes(params[:nr_parameter])
        flash[:notice] = 'NetRestore parameter was successfully updated.'
        format.html { redirect_to(@nr_parameter) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @nr_parameter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /nr_parameters/1
  # DELETE /nr_parameters/1.xml
  def destroy
    @nr_parameter = NrParameter.find(params[:id])
    @nr_parameter.destroy

    respond_to do |format|
      format.html { redirect_to(nr_parameters_url) }
      format.xml  { head :ok }
    end
  end
end
