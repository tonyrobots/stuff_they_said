require 'test_helper'

class WhoisControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Whois.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Whois.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Whois.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to whois_url(assigns(:whois))
  end
  
  def test_edit
    get :edit, :id => Whois.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Whois.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Whois.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Whois.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Whois.first
    assert_redirected_to whois_url(assigns(:whois))
  end
  
  def test_destroy
    whois = Whois.first
    delete :destroy, :id => whois
    assert_redirected_to whois_url
    assert !Whois.exists?(whois.id)
  end
end
