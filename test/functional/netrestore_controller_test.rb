require File.dirname(__FILE__) + '/../test_helper'
require 'netrestore_controller'

# Re-raise errors caught by the controller.
class NetrestoreController; def rescue_action(e) raise e end; end

class NetrestoreControllerTest < Test::Unit::TestCase
  def setup
    @controller = NetrestoreController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
