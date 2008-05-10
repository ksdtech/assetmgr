class TicketItemsController < ApplicationController
  # GET /ticket_items
  # GET /ticket_items.xml
  def index
    @ticket_items = TicketItem.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ticket_items }
    end
  end

  # GET /ticket_items/1
  # GET /ticket_items/1.xml
  def show
    @ticket_item = TicketItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ticket_item }
    end
  end

  # GET /ticket_items/new
  # GET /ticket_items/new.xml
  def new
    @ticket_item = TicketItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ticket_item }
    end
  end

  # GET /ticket_items/1/edit
  def edit
    @ticket_item = TicketItem.find(params[:id])
  end

  # POST /ticket_items
  # POST /ticket_items.xml
  def create
    @ticket_item = TicketItem.new(params[:ticket_item])

    respond_to do |format|
      if @ticket_item.save
        flash[:notice] = 'TicketItem was successfully created.'
        format.html { redirect_to(@ticket_item) }
        format.xml  { render :xml => @ticket_item, :status => :created, :location => @ticket_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ticket_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ticket_items/1
  # PUT /ticket_items/1.xml
  def update
    @ticket_item = TicketItem.find(params[:id])

    respond_to do |format|
      if @ticket_item.update_attributes(params[:ticket_item])
        flash[:notice] = 'TicketItem was successfully updated.'
        format.html { redirect_to(@ticket_item) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ticket_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ticket_items/1
  # DELETE /ticket_items/1.xml
  def destroy
    @ticket_item = TicketItem.find(params[:id])
    @ticket_item.destroy

    respond_to do |format|
      format.html { redirect_to(ticket_items_url) }
      format.xml  { head :ok }
    end
  end
end
