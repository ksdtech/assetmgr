require 'zip/zip'
require 'zip/zipfilesystem'

class DeploystudioController < ApplicationController
  def index
    loc = params[:loc]
    conds = if loc
      [ "mac_address<>'' AND machine_group_id IS NOT NULL AND status=? AND location_site LIKE ?", 'active', "#{loc}\%" ]
    else
      [ "mac_address<>'' AND machine_group_id IS NOT NULL AND status=?", 'active' ]
    end
    @hosts = Computer.find(:all, :conditions => conds, :order => 'mac_address')
    if params[:zip]
      Tempfile.open("ds.#{request.remote_ip}", File.join(Rails.root, "public/tempfiles")) do |t|
        # Remember the path for the send_file command
        @tempfile_path = t.path
        
        # Give the path of the temp file to the zip outputstream, it won't try to open it as an archive.
        Zip::ZipOutputStream.open(t.path) do |zos|
          @hosts.each do |host|
            # Create a new entry in the zip archive with the machine mac address
            fname = "#{host.mac_address.gsub(/:/, '')}.plist"
            zos.put_next_entry(fname)
            
            # Render and add the plist
            @host = host
            plist_str = render_to_string(:action => 'show', :layout => 'blank')
            zos.print plist_str
          end
        end
      end
      # Send the file
      send_file(@tempfile_path, :type => 'application/zip', 
        :disposition => 'attachment', :filename => "deploystudio-byhost.zip")
    else
      render :action => 'index', :layout => 'blank'
    end
  end
end
