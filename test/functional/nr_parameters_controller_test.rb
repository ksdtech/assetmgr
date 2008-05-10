require File.dirname(__FILE__) + '/../test_helper'
require 'nr_parameters_controller'

# Re-raise errors caught by the controller.
class NrParametersController; def rescue_action(e) raise e end; end

class NrParametersControllerTest < Test::Unit::TestCase
  fixtures :nr_parameters

  def setup
    @controller = NrParametersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = nr_parameters(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:nr_parameters)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:nr_parameter)
    assert assigns(:nr_parameter).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:nr_parameter)
  end

  def test_create
    num_nr_parameters = NrParameter.count

    post :create, :nr_parameter => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_nr_parameters + 1, NrParameter.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:nr_parameter)
    assert assigns(:nr_parameter).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      NrParameter.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      NrParameter.find(@first_id)
    }
  end
end
