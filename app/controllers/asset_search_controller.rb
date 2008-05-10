class AssetSearchController < ApplicationController
  
  # GET /search
  def index
    @query = params[:query]
    @sel = params[:sel]
    render :template => 'assets/livesearch', :layout => false
  end
end
