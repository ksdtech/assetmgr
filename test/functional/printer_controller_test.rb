require File.dirname(__FILE__) + '/../test_helper'
require 'printer_controller'

# Re-raise errors caught by the controller.
class PrinterController; def rescue_action(e) raise e end; end

class PrinterControllerTest < Test::Unit::TestCase
  def setup
    @controller = PrinterController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
