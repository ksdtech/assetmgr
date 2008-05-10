module InventoryHelper
  
  def link_to_asset_on(obj, foreign_key, this_key)
    sql = "SELECT id, `type` FROM assets WHERE #{foreign_key} LIKE '#{obj[this_key]}'"
    assets = Asset.find_by_sql(sql)
    if assets.size == 1
      a = assets.first
      path = case a[:type].to_s
      when 'Computer' then 'edit_computer_path'
      when 'Printer' then 'edit_printer_path'
      when 'NetDevice' then 'edit_network_item_path'
      when 'WirelessDevice' then 'edit_wireless_item_path'
      when 'OtherAsset' then 'edit_other_path'
      else
        nil
      end
      return link_to(obj[this_key], send(path, a.id)) unless path.nil?
    end
    return h(obj[this_key])
  end
end
