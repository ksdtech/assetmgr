require File.dirname(__FILE__) + '/../test_helper'

class TicketCategoriesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:ticket_categories)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_ticket_category
    assert_difference('TicketCategory.count') do
      post :create, :ticket_category => { }
    end

    assert_redirected_to ticket_category_path(assigns(:ticket_category))
  end

  def test_should_show_ticket_category
    get :show, :id => ticket_categories(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => ticket_categories(:one).id
    assert_response :success
  end

  def test_should_update_ticket_category
    put :update, :id => ticket_categories(:one).id, :ticket_category => { }
    assert_redirected_to ticket_category_path(assigns(:ticket_category))
  end

  def test_should_destroy_ticket_category
    assert_difference('TicketCategory.count', -1) do
      delete :destroy, :id => ticket_categories(:one).id
    end

    assert_redirected_to ticket_categories_path
  end
end
