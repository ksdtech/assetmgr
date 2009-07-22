# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'user'

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_assetmgr_session_id'
  before_filter :authenticate
  
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      u = User.authenticate(username, password)
      session[:user] = u.nil? ? nil : u.id
      session[:admin] = !u.nil? && u.administrator?
      session[:help_staff] = !u.nil? && u.accepts_assignments?
      session[:full_name] = u.nil? ? 'Guest' : u.full_name
      return false if u.nil?
      
      u.update_attributes(:last_access_at => Time.now, :last_access_from => request.env['REMOTE_ADDR'])
      true
    end
  end
end
