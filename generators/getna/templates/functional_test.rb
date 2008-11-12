require File.dirname(__FILE__) + '/../test_helper'

class <%= object_name[:class_plural] %>ControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:<%=object_name[:plural] %>)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_<%=object_name[:single] %>
    assert_difference('<%=object_name[:class] %>.count') do
      post :create, :<%=object_name[:single] %> => { }
    end

    assert_redirected_to <%=object_name[:single] %>_path(assigns(:<%=object_name[:single] %>))
  end

  def test_should_show_<%=object_name[:single] %>
    get :show, :id => <%=object_name[:plural] %>(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => <%=object_name[:plural] %>(:one).id
    assert_response :success
  end

  def test_should_update_<%=object_name[:single] %>
    put :update, :id => <%=object_name[:plural] %>(:one).id, :<%=object_name[:single] %> => { }
    assert_redirected_to <%=object_name[:single] %>_path(assigns(:<%=object_name[:single] %>))
  end

  def test_should_destroy_<%=object_name[:single] %>
    assert_difference('<%=object_name[:class] %>.count', -1) do
      delete :destroy, :id => <%=object_name[:plural] %>(:one).id
    end

    assert_redirected_to <%=object_name[:plural] %>_path
  end
end
