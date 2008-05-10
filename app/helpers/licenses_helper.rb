module LicensesHelper
  
  def info(l)
    [l.serial_number, l.install_key, l.use, l.location, l.notes].select { |f| !f.blank? }.join('<br/>')
  end
end
