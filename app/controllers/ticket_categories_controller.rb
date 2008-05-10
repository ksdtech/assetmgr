class TicketCategoriesController < ApplicationController
  # GET /ticket_categories
  # GET /ticket_categories.xml
  def index
    @ticket_categories = TicketCategory.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ticket_categories }
    end
  end

  # GET /ticket_categories/1
  # GET /ticket_categories/1.xml
  def show
    @ticket_category = TicketCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ticket_category }
    end
  end

  # GET /ticket_categories/new
  # GET /ticket_categories/new.xml
  def new
    @ticket_category = TicketCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ticket_category }
    end
  end

  # GET /ticket_categories/1/edit
  def edit
    @ticket_category = TicketCategory.find(params[:id])
  end

  # POST /ticket_categories
  # POST /ticket_categories.xml
  def create
    @ticket_category = TicketCategory.new(params[:ticket_category])

    respond_to do |format|
      if @ticket_category.save
        flash[:notice] = 'TicketCategory was successfully created.'
        format.html { redirect_to(@ticket_category) }
        format.xml  { render :xml => @ticket_category, :status => :created, :location => @ticket_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ticket_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ticket_categories/1
  # PUT /ticket_categories/1.xml
  def update
    @ticket_category = TicketCategory.find(params[:id])

    respond_to do |format|
      if @ticket_category.update_attributes(params[:ticket_category])
        flash[:notice] = 'TicketCategory was successfully updated.'
        format.html { redirect_to(@ticket_category) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ticket_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ticket_categories/1
  # DELETE /ticket_categories/1.xml
  def destroy
    @ticket_category = TicketCategory.find(params[:id])
    @ticket_category.destroy

    respond_to do |format|
      format.html { redirect_to(ticket_categories_url) }
      format.xml  { head :ok }
    end
  end
end
