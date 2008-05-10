# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def logged_in?
    !session[:user].nil?
  end
  
  def administrator?
    session[:admin]
  end
  
  def help_staff?
    session[:help_staff]
  end
  
  def logged_in_user
    session[:full_name]
  end
  
  def options_for_asset_link(query='', sel=nil)
    sel = sel.nil? ? 0 : sel.to_i
    opts = [ [ 'Select asset...', 0 ], [ 'Remove asset link', -1 ] ]
    if !query.blank?
      page_params = { :page => 1, :query => query }
      assets = Asset.paginated_collection(Asset.per_page, page_params, Asset.search_rules, Asset.find_options)
      assets.each { |a| opts.push( [ a.option_text, a.id ] ) }
    end
    options_for_select(opts, sel)
  end
  
  # http://blog.andreasaderhold.com/2006/07/rails-notifications
  def notify(type, message)
    type = type.to_s  # symbol to string
    page.replace 'flash', "<h4 id='flash' class='alert #{type}'>#{message}</h4>" 
    page.visual_effect :fade, 'flash', :duration => 8.0
  end
  
  # http://dev.nozav.org/rails_ajax_table.html
  def sort_td_class_helper(param)
    return 'class="sort"'  if params[:sort] == param
    return 'class="rsort"' if params[:rsort] == param
    ''
  end
  
  # http://dev.nozav.org/rails_ajax_table.html
  def sort_link_helper(text, param)
    link_params = params.dup
    if params[:sort] == param
      link_params[:rsort] = param
      link_params.delete(:sort)
    else
      link_params[:sort] = param
      link_params.delete(:rsort)
    end
    link_params[:page] = 1
    options = {
        :url     => link_params,
        :method  => 'get',
        :before  => "Element.show('spinner')",
        :success => "Element.hide('spinner')"
    }
    html_options = {
      :title => "Sort by this field",
      :href => url_for(:params => link_params)
    }
    link_to(text, html_options[:href])
    # link_to_remote(text, options, html_options)
  end

  def ymd(date)
    date.nil? ? '' : date.strftime("%Y/%m/%d")
  end
  
  def ymdhmp(date)
    date.nil? ? '' : date.strftime("%Y/%m/%d - %I:%M %p")
  end
end
