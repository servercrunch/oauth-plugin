require "mocha"
module OAuthControllerTestHelper
  
  # Some custom stuff since we're using Mocha
  def mock_model(model_class, options_and_stubs = {})
    id = rand(10000)
    options_and_stubs.reverse_merge! :id => id,
      :to_param => id.to_s,
      :new_record? => false,
      :errors => stub("errors", :count => 0)
      
    m = stub("#{model_class.name}_#{options_and_stubs[:id]}", options_and_stubs)
    m.instance_eval <<-CODE
      def is_a?(other)
        #{model_class}.ancestors.include?(other)
      end
      def kind_of?(other)
        #{model_class}.ancestors.include?(other)
      end
      def instance_of?(other)
        other == #{model_class}
      end
      def class
        #{model_class}
      end
    CODE
    yield m if block_given?
    m
  end
    
  def mock_full_oauth_application
    mock_model(OauthApplication, 
                :name => "App1", 
                :url => "http://app.com", 
                :callback_url => "http://app.com/callback",
                :support_url => "http://app.com/support",
                :key => "asd23423yy",
                :secret => "secret",
                :oauth_server => OAuth::Server.new("http://kowabunga.com")
              )
  end
  
  def login
    @controller.stubs(:local_request?).returns(true)
    @user = mock_model(User, :login => "ron")
    @controller.stubs(:current_user).returns(@user)
    @tokens=[]
    @tokens.stubs(:find).returns(@tokens)
    @user.stubs(:tokens).returns(@tokens)
    User.stubs(:find_by_id).returns(@user)
  end
  
  def login_as_application_owner
    login
    @oauth_application = mock_full_oauth_application
    @oauth_applications = [@oauth_application]
    
    @user.stubs(:oauth_applications).returns(@oauth_applications)
    @oauth_applications.stubs(:find).returns(@oauth_application)
  end
  
  def setup_oauth
    @controller.stubs(:local_request?).returns(true)
    @user||=mock_model(User)
    
    User.stubs(:find_by_id).returns(@user)
    
    @server=OAuth::Server.new "http://test.host"
    @consumer=OAuth::Consumer.new('key','secret',{:site=>"http://test.host"})

    @oauth_application = mock_full_oauth_application
    @controller.stubs(:current_oauth_application).returns(@oauth_application)
    OauthApplication.stubs(:find_by_key).returns(@oauth_application)
    @oauth_application.stubs(:key).returns(@consumer.key)
    @oauth_application.stubs(:secret).returns(@consumer.secret)
    @oauth_application.stubs(:name).returns("Client Application name")
    @oauth_application.stubs(:callback_url).returns("http://application/callback")
    @request_token=mock_model(RequestToken,:token=>'request_token',:oauth_application=>@oauth_application,:secret=>"request_secret",:user=>@user)
    @request_token.stubs(:invalidated?).returns(false)
    OauthApplication.stubs(:find_token).returns(@request_token)
    
    @request_token_string="oauth_token=request_token&oauth_token_secret=request_secret"
    @request_token.stubs(:to_query).returns(@request_token_string)

    @access_token=mock_model(AccessToken,:token=>'access_token',:oauth_application=>@oauth_application,:secret=>"access_secret",:user=>@user)
    @access_token.stubs(:invalidated?).returns(false)
    @access_token.stubs(:authorized?).returns(true)
    @access_token_string="oauth_token=access_token&oauth_token_secret=access_secret"
    @access_token.stubs(:to_query).returns(@access_token_string)

    @oauth_application.stubs(:authorize_request?).returns(true)
#    @oauth_application.stubs(:sign_request_with_oauth_token).returns(@request_token)
    @oauth_application.stubs(:exchange_for_access_token).returns(@access_token)
  end
  
  def setup_oauth_for_user
    login
    setup_oauth
    @tokens=[@request_token]
    @tokens.stubs(:find).returns(@tokens)
    @tokens.stubs(:find_by_token).returns(@request_token)
    @user.stubs(:tokens).returns(@tokens)
  end
  
  def sign_request_with_oauth(token=nil)
    ActionController::TestRequest.use_oauth=true
    @request.configure_oauth(@consumer, token)
  end
    
  def setup_to_authorize_request
    setup_oauth
    OauthToken.stubs(:find_by_token).with( @access_token.token).returns(@access_token)
    @access_token.stubs(:is_a?).returns(true)
  end
end
