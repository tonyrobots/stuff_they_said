require 'test_helper'

class StatementsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Statement.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Statement.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Statement.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to statement_url(assigns(:statement))
  end
  
  def test_edit
    get :edit, :id => Statement.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Statement.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Statement.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Statement.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Statement.first
    assert_redirected_to statement_url(assigns(:statement))
  end
  
  def test_destroy
    statement = Statement.first
    delete :destroy, :id => statement
    assert_redirected_to statements_url
    assert !Statement.exists?(statement.id)
  end
end
