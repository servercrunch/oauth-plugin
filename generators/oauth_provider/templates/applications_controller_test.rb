require File.dirname(__FILE__) + '/../test_helper'
require 'oauth/client/action_controller_request'

class OauthApplicationsController; def rescue_action(e) raise e end; end

class OauthApplicationsControllerIndexTest < ActionController::TestCase
  include OAuthControllerTestHelper
  tests OauthApplicationsController
  
  def setup    
    @controller = OauthApplicationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new    
    
    login_as_application_owner
  end
  
  def do_get
    get :index
  end
  
  def test_should_be_successful
    do_get
    assert @response.success?
  end
  
  def test_should_query_current_users_oauth_applications
    @user.expects(:oauth_applications).returns(@oauth_applications)
    do_get
  end
  
  def test_should_assign_oauth_applications
    do_get
    assert_equal @oauth_applications, assigns(:oauth_applications)
  end
  
  def test_should_render_index_template
    do_get
    assert_template 'index'
  end
end

class OauthApplicationsControllerShowTest < ActionController::TestCase
  include OAuthControllerTestHelper
  tests OauthApplicationsController
  
  def setup
    @controller = OauthApplicationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new    
    
    login_as_application_owner
  end
  
  def do_get
    get :show, :id => '3'
  end
  
  def test_should_be_successful
    do_get
    assert @response.success?
  end
  
  def test_should_query_current_users_oauth_applications
    @user.expects(:oauth_applications).returns(@oauth_applications)
    @oauth_applications.expects(:find).with('3').returns(@oauth_application)
    do_get
  end
  
  def test_should_assign_oauth_applications
    do_get
    assert_equal @oauth_application, assigns(:oauth_application)
  end
  
  def test_should_render_show_template
    do_get
    assert_template 'show'
  end
  
end

class OauthApplicationsControllerNewTest < ActionController::TestCase
  include OAuthControllerTestHelper
  tests OauthApplicationsController

  def setup
    @controller = OauthApplicationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new    
    
    login_as_application_owner
    OauthApplication.stubs(:new).returns(@oauth_application)
  end
  
  def do_get
    get :new
  end
  
  def test_should_be_successful
    do_get
    assert @response.success?
  end
  
  def test_should_assign_oauth_applications
    do_get
    assert_equal @oauth_application, assigns(:oauth_application)
  end
  
  def test_should_render_show_template
    do_get
    assert_template 'new'
  end
  
end
 
class OauthApplicationsControllerEditTest < ActionController::TestCase
  include OAuthControllerTestHelper
  tests OauthApplicationsController
  
  def setup
    @controller = OauthApplicationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new    

    login_as_application_owner
  end
  
  def do_get
    get :edit, :id=>'3'
  end
  
  def test_should_be_successful
    do_get
    assert @response.success?
  end
  
  def test_should_query_current_users_oauth_applications
    @user.expects(:oauth_applications).returns(@oauth_applications)
    @oauth_applications.expects(:find).with('3').returns(@oauth_application)
    do_get
  end
  
  def test_should_assign_oauth_applications
    do_get
    assert_equal @oauth_application, assigns(:oauth_application)
  end
  
  def test_should_render_edit_template
    do_get
    assert_template 'edit'
  end
  
end

class OauthApplicationsControllerCreateTest < ActionController::TestCase
  include OAuthControllerTestHelper
  tests OauthApplicationsController
  
  def setup
    @controller = OauthApplicationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new    
    
    login_as_application_owner
    @oauth_applications.stubs(:build).returns(@oauth_application)
    @oauth_application.stubs(:save).returns(true)
  end
  
  def do_valid_post
    @oauth_application.expects(:save).returns(true)
    post :create,'oauth_application' => {'name' => 'my site'}
  end

  def do_invalid_post
    @oauth_application.expects(:save).returns(false)
    post :create,:oauth_application=>{:name => 'my site'}
  end
  
  def test_should_query_current_users_oauth_applications
    @oauth_applications.expects(:build).returns(@oauth_application)
    do_valid_post
  end
  
  def test_should_redirect_to_new_oauth_application
    do_valid_post
    assert_response :redirect
    assert_redirected_to(:action => "show", :id => @oauth_application.id)
  end
  
  def test_should_assign_oauth_applications
    do_invalid_post
    assert_equal @oauth_application, assigns(:oauth_application)
  end
  
  def test_should_render_show_template
    do_invalid_post
    assert_template('new')
  end
end
 
class OauthApplicationsControllerDestroyTest < ActionController::TestCase
  include OAuthControllerTestHelper
  tests OauthApplicationsController
  
  def setup
    @controller = OauthApplicationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    login_as_application_owner
    @oauth_application.stubs(:destroy)
  end
  
  def do_delete
    delete :destroy,:id=>'3'
  end
    
  def test_should_query_current_users_oauth_applications
    @user.expects(:oauth_applications).returns(@oauth_applications)
    @oauth_applications.expects(:find).with('3').returns(@oauth_application)
    do_delete
  end

  def test_should_destroy_oauth_applications
    @oauth_application.expects(:destroy)
    do_delete
  end
    
  def test_should_redirect_to_list
    do_delete
    assert_response :redirect
    assert_redirected_to :action => 'index'
  end
  
end

class OauthApplicationsControllerUpdateTest < ActionController::TestCase
  include OAuthControllerTestHelper
  tests OauthApplicationsController

  def setup
    @controller = OauthApplicationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as_application_owner
  end
  
  def do_valid_update
    @oauth_application.expects(:update_attributes).returns(true)
    put :update, :id => '1', 'oauth_application' => {'name' => 'my site'}
  end

  def do_invalid_update
    @oauth_application.expects(:update_attributes).returns(false)
    put :update, :id=>'1', 'oauth_application' => {'name' => 'my site'}
  end
  
  def test_should_query_current_users_oauth_applications
    @user.expects(:oauth_applications).returns(@oauth_applications)
    @oauth_applications.expects(:find).with('1').returns(@oauth_application)
    do_valid_update
  end
  
  def test_should_redirect_to_new_oauth_application
    do_valid_update
    assert_response :redirect
    assert_redirected_to :action => "show", :id => @oauth_application.id
  end
  
  def test_should_assign_oauth_applications
    do_invalid_update
    assert_equal @oauth_application, assigns(:oauth_application)
  end
  
  def test_should_render_show_template
    do_invalid_update
    assert_template('edit')
  end
end
