require File.dirname(__FILE__) + '/../test_helper'
require 'ticket_controller'

# Re-raise errors caught by the controller.
class TicketController; def rescue_action(e) raise e end; end

class TicketControllerTest < Test::Unit::TestCase
  def setup
    @controller = TicketController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
