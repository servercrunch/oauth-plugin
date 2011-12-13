module Mongoid
  module Generators
    class OauthProviderGenerator < Rails::Generators::Base
      source_root File.expand_path('../oauth_provider_templates', __FILE__)

      def check_class_collisions
        class_collisions '', %w(OauthApplication OauthNonce RequestToken AccessToken OauthToken)
      end

      def copy_models
        template 'oauth_application.rb', File.join('app/models', 'oauth_application.rb')
        template 'oauth_token.rb',        File.join('app/models', 'oauth_token.rb')
        template 'request_token.rb',      File.join('app/models', 'request_token.rb')
        template 'access_token.rb',       File.join('app/models', 'access_token.rb')
        template 'oauth2_token.rb',       File.join('app/models', 'oauth2_token.rb')
        template 'oauth2_verifier.rb',    File.join('app/models', 'oauth2_verifier.rb')
        template 'oauth_nonce.rb',        File.join('app/models', 'oauth_nonce.rb')
      end
    end
  end
end
