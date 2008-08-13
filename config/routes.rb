ActionController::Routing::Routes.draw do |map|

  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"
  
  map.resources :users
  map.resources :sites
  map.resources :ticket_categories

  map.resources :computers, :member => { :update_from_ard => :post }, :collection => { :action => :post }
  map.resources :printers, :collection => { :action => :post }
  map.resources :wireless,  :singular => 'wireless_item', :collection => { :action => :post }
  map.resources :network,   :singular => 'network_item', :collection => { :action => :post }
  map.resources :others, :collection => { :action => :post }
  
  map.resources :ethers, :name_prefix => 'asset_', :path_prefix => '/assets/:asset_id'
  
  map.resources :tickets
  map.resources :tickets, :name_prefix => 'asset_', :path_prefix => '/assets/:asset_id'
  map.resources :tickets, :name_prefix => 'requested_', :path_prefix => '/users/:requestor_id'
  map.resources :tickets, :name_prefix => 'assigned_', :path_prefix => '/users/:assignee_id'
  map.resources :ticket_items
  
  map.resources :inventory, :singular => 'inventory_item'
  map.resources :licenses
  map.resources :machine_groups
  
  map.resources :nr_configurations
  map.resources :nr_parameters

  map.connect '', :controller => 'computers', :action => 'index'
  
  map.connect 'search', :controller => 'asset_search', :action => 'index'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:id/:action.:format'
  map.connect ':controller/:id/:action'
end
