require File.dirname(__FILE__) + '/../test_helper'

class RequestTokenTest < ActiveSupport::TestCase

  fixtures :oauth_applications, :users, :oauth_tokens
  
  def setup
    @token = RequestToken.create :oauth_application=>oauth_applications(:one)
  end

  def test_should_be_valid
    assert @token.valid?
  end
  
  def test_should_not_have_errors
    assert @token.errors.empty?
  end
  
  def test_should_have_a_token
    assert_not_nil @token.token
  end

  def test_should_have_a_secret
    assert_not_nil @token.secret
  end
  
  def test_should_not_be_authorized 
    assert !@token.authorized?
  end

  def test_should_not_be_invalidated
    assert !@token.invalidated?
  end
  
  def test_should_authorize_request
    @token.authorize!(users(:quentin))
    assert @token.authorized?
    assert_not_nil @token.authorized_at
    assert_equal users(:quentin), @token.user
  end
  
  def test_should_not_exchange_without_approval
    assert_equal false, @token.exchange!
    assert_equal false, @token.invalidated?
  end

  def test_should_exchange_with_verifier
    @token.authorize!(users(:quentin))
    assert @token.authorized?
    @token.provided_oauth_verifier = @token.verifier
    @access = @token.exchange!
    assert_equal true, @access
    assert @token.invalidated?
    
    assert_equal users(:quentin), @access.user
    assert @access.authorized?
  end
   
  def test_should_not_exchange_without_verifier
    @token.authorize!(users(:quentin))
    @access = @token.exchange!
    assert_equal false, @access
  end
  
end
