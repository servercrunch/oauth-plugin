require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/oauth_controller_spec_helper'
require 'oauth/client/action_controller_request'

describe OauthApplicationsController do
  if defined?(Devise)
    include Devise::TestHelpers
  end  
  include OAuthControllerSpecHelper
  fixtures :oauth_applications, :oauth_tokens, :users
  before(:each) do
    login_as_application_owner
  end
  
  describe "index" do
    before do
      @oauth_applications = @user.oauth_applications
    end
    
    def do_get
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should assign oauth_applications" do
      do_get
      assigns[:oauth_applications].should==@oauth_applications
    end
  
    it "should render index template" do
      do_get
      response.should render_template('index')
    end
  end

  describe "show" do

    def do_get
      get :show, :id => '1'
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should assign oauth_applications" do
      do_get
      assigns[:oauth_application].should == current_oauth_application
    end
  
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
  
  end

  describe "new" do
  
    def do_get
      get :new
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should assign oauth_applications" do
      do_get
      assigns[:oauth_application].class.should == OauthApplication
    end
  
    it "should render show template" do
      do_get
      response.should render_template('new')
    end
  
  end

  describe "edit" do
    def do_get
      get :edit, :id => '1'
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should assign oauth_applications" do
      do_get
      assigns[:oauth_application].should == current_oauth_application
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
  end

  describe "create" do
    
    def do_valid_post
      post :create, 'oauth_application' => {'name' => 'my site', :url => "http://test.com"}
      @oauth_application = OauthApplication.last
    end

    def do_invalid_post
      post :create
    end
    
    it "should redirect to new oauth_application" do
      do_valid_post
      response.should be_redirect
      response.should redirect_to(:action => "show", :id => @oauth_application.id)
    end
  
    it "should render show template" do
      do_invalid_post
      response.should render_template('new')
    end
  end

  describe "destroy" do
  
    def do_delete
      delete :destroy, :id => '1'
    end
    
    it "should destroy client applications" do
      do_delete
      OauthApplication.should_not be_exists(1)
    end
    
    it "should redirect to list" do
      do_delete
      response.should be_redirect
      response.should redirect_to(:action => 'index')
    end
  
  end

  describe "update" do
  
    def do_valid_update
      put :update, :id => '1', 'oauth_application' => {'name' => 'updated site'}
    end

    def do_invalid_update
      put :update, :id => '1', 'oauth_application' => {'name' => nil}
    end
  
    it "should redirect to show oauth_application" do
      do_valid_update
      response.should be_redirect
      response.should redirect_to(:action => "show", :id => 1)
    end
  
    it "should assign oauth_applications" do
      do_invalid_update
      assigns[:oauth_application].should == OauthApplication.find(1)
    end
  
    it "should render show template" do
      do_invalid_update
      response.should render_template('edit')
    end
  end
end
