class TicketsController < ApplicationController
  before_filter :set_paths
  
  def set_paths
    if params[:asset_id]
      @coll_url = asset_tickets_url(params[:asset_id])
    else
      @coll_url = tickets_url
    end
  end
  
  # GET /tickets
  # GET /tickets.xml
  def index
    a = nil
    a = Asset.find(params[:asset_id]) if params[:asset_id]
    if !a.nil?
      @content_title = @title = "Trouble Tickets for #{a.title}"
      @new_memb_path = new_asset_ticket_path(a.id)
      @back_path = send(a.coll_path)
      @conds = ['asset_id=?', a.id]
      @show_asset = false
    else
      @content_title = @title = 'All Trouble Tickets'
      @new_memb_path = new_ticket_path
      @conds = nil
      @show_asset = true
    end
    
    @tickets = Ticket.paginated_collection(Ticket.per_page, params, Ticket.search_rules, Ticket.find_options.merge(:conditions => @conds))
    
    if request.xml_http_request?
      render :partial => 'list', :layout => false
      return
    end

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @tickets.to_xml }
    end
  end

  # GET /tickets/1
  # GET /tickets/1.xml
  def show
    @ticket = Ticket.find(params[:id])

    respond_to do |format|
      format.html { redirect_to edit_ticket_url(@ticket) }
      format.xml  { render :xml => @ticket.to_xml }
    end
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new(:importance => 2)
    @ticket_item = TicketItem.new
    @ticket.requestor = User.find(session[:user])
    
    a = params[:asset_id] ? Asset.find(params[:asset_id]) : nil
    if a.nil?
      @title = 'Editing new ticket' 
    else
      @ticket.asset_link = a.id
      # new_record? check will suppress selection of asset in view
      @title = "Editing new ticket for #{a.title}"
    end
    @content_title = @title
    @submit_value = 'Create'
  end

  # GET /tickets/1;edit
  def edit
    @ticket = Ticket.find(params[:id])
    a = @ticket.asset
    if a.nil?
      @title = 'Editing ticket #{@ticket.id}' 
    else
      @title = "Editing ticket #{@ticket.id} for #{a.title}"
    end
    @content_title = @title
    @submit_value = 'Update'
  end

  # POST /tickets
  # POST /tickets.xml
  def create
    @ticket = Ticket.new(params[:ticket])
    @ticket.previous_assignee_id = nil
    @ticket.updater_id = session[:user]
    
    respond_to do |format|
      if @ticket.save
        flash[:notice] = 'Ticket was successfully created.'
        format.html { redirect_to @coll_url }
        format.xml  { head :created, :location => ticket_url(@ticket) }
      else
        @content_title = @title = @ticket.asset.nil? ? 'Editing new ticket' : "Editing new ticket for #{a.title}"
        @submit_value = 'Create'
        format.html { render :action => "new" }
        format.xml  { render :xml => @ticket.errors.to_xml }
      end
    end
  end

  # PUT /tickets/1
  # PUT /tickets/1.xml
  def update
    @ticket = Ticket.find(params[:id])
    @ticket.previous_assignee_id = @ticket.assignee_id
    @ticket.updater_id = session[:user]

    respond_to do |format|
      if @ticket.update_attributes(params[:ticket])
        flash[:notice] = 'Ticket was successfully updated.'
        format.html { redirect_to @coll_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ticket.errors.to_xml }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.xml
  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy

    respond_to do |format|
      flash[:notice] = 'Ticket was successfully deleted.'
      format.html { redirect_to @coll_url }
      format.xml  { head :ok }
    end
  end
end
