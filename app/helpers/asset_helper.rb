
module AssetHelper
  def machine_group_options
    options_from_collection_for_select(
      MachineGroup.find(:all, :order => 'name ASC'), 
      'id', 'name')
  end

  def link_to_machine_group(obj)
    if !obj.respond_to?(:machine_group) || obj.machine_group.nil?
      ''
    else
      mg = obj.machine_group
      link_to(mg.name, machine_group_path(mg.id))
    end
  end

  def inventory_check(inv)
    inv ? '<input type="checkbox" disabled="disabled" checked="checked" />' : '&nbsp;'
  end
  
  def duplicate_class_if(test)
    return test ? ' class="duplicate" ' : ''
  end
  
  def link_to_inventory_on(obj, foreign_key, this_key)
    sql = "SELECT barcode FROM asset_records WHERE #{foreign_key} LIKE '#{obj[this_key]}'"
    assets = AssetRecord.find_by_sql(sql)
    if assets.size == 1
      a = assets.first
      return link_to(obj[this_key], inventory_item_path(a.id))
    end
    return h(obj[this_key])
  end

  def with_current_tag
    params[:tag].blank? ? '' : " with tag <b>#{params[:tag]}</b>"
  end
  
  def tag_links(klass, tagged_klass=Asset)
    options = {
      :method  => 'get',
      :before  => "Element.show('spinner')",
      :success => "Element.hide('spinner')"
    }
    
    link_params = params.clone.merge( { :tag => '' } )
    options[:url] = link_params
    html_options = { :href => url_for(:params => link_params) }
    show_all_link = link_to_remote('Show All', options, html_options)
    
    class_tags = tagged_klass.tag_counts(:conditions => [ "#{klass.table_name}.`type` = ?", klass.name ]).
      sort { |a,b| a.name <=> b.name }
    links = class_tags.collect do |tag| 
      link_params = params.clone.merge( { :tag => tag.name } )
      options[:url] = link_params
      html_options = { :href => url_for(:params => link_params) }
      link_to(tag.name, html_options[:href])
      # link_to_remote(tag.name, options, html_options)
    end

    return links.join(' ') + ' | ' + show_all_link
  end
  
  def tickets_links(a)
    s = ''
    if a.tickets.count > 0
      s << link_to( "#{a.tickets.count}", asset_tickets_path(a.id) )
      s << "&nbsp;"
    end
    s << link_to( "Add", new_asset_ticket_path(a.id) )
    s
  end
end
