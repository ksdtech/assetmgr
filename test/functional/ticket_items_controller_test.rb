require File.dirname(__FILE__) + '/../test_helper'

class TicketItemsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:ticket_items)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_ticket_item
    assert_difference('TicketItem.count') do
      post :create, :ticket_item => { }
    end

    assert_redirected_to ticket_item_path(assigns(:ticket_item))
  end

  def test_should_show_ticket_item
    get :show, :id => ticket_items(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => ticket_items(:one).id
    assert_response :success
  end

  def test_should_update_ticket_item
    put :update, :id => ticket_items(:one).id, :ticket_item => { }
    assert_redirected_to ticket_item_path(assigns(:ticket_item))
  end

  def test_should_destroy_ticket_item
    assert_difference('TicketItem.count', -1) do
      delete :destroy, :id => ticket_items(:one).id
    end

    assert_redirected_to ticket_items_path
  end
end
