require File.dirname(__FILE__) + '/../test_helper'
require 'wireless_controller'

# Re-raise errors caught by the controller.
class WirelessController; def rescue_action(e) raise e end; end

class WirelessControllerTest < Test::Unit::TestCase
  def setup
    @controller = WirelessController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
