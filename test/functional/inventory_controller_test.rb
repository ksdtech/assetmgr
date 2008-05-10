require File.dirname(__FILE__) + '/../test_helper'
require 'inventory_controller'

# Re-raise errors caught by the controller.
class InventoryController; def rescue_action(e) raise e end; end

class InventoryControllerTest < Test::Unit::TestCase
  def setup
    @controller = InventoryController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
