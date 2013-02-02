require 'dossia/client'
require 'dossia/client/users'

require 'oauth'
require 'active_support/core_ext'
require 'hashie'

module Dossia

  class Client

    DOSSIA_URL = ENV['DOSSIA_URL'] || 'https://staging-oauth.dossia.org'

    include Dossia::Users

    def access_token
      @access_token
    end

    def initialize( options = {} )

      unless options.kind_of? Hash
        raise Dossia::ConfigurationError, "Options hash required"
      end

      raise Dossia::ConfigurationError, "Client needs to be configured" if Dossia.configuration.keys.length == 0 

      @consumer = OAuth::Consumer.new( Dossia.configuration[ :consumer_key ], Dossia.configuration[ :consumer_secret ], {
        :site => DOSSIA_URL,
        :request_token_path => "/authserver/request_token",
        :authorize_path => "/authserver/authorize",
        :access_token_path => "/authserver/access_token"
      } )

      if options[ :request_token ]
        request_token = OAuth::RequestToken.new(@consumer, options[ :request_token ], '')
        @access_token = request_token.get_access_token
      elsif options[ :oauth_token ] and options[ :oauth_token_secret ]
        @access_token = OAuth::AccessToken.new( @consumer, options[ :oauth_token ], options[ :oauth_token_secret ] )
      else
        @access_token = OAuth::AccessToken.new( @consumer, Dossia.configuration[ :oauth_token ], Dossia.configuration[ :oauth_token_secret ] )
      end

      @record = Hashie::Mash.new get('/records')

    end 

    def delete( path, params = nil )
      path = "#{path}?#{params.map{|k,v|"#{k}=#{v}"}.join('&')}" if params
      parse( @access_token.path( DOSSIA_URL + '/dossia-restful-api/services/v3.0' + path ) )
    end

    def get( path, params = nil )
      path = "#{path}?#{params.map{|k,v|"#{k}=#{v}"}.join('&')}" if params
      parse( @access_token.get( DOSSIA_URL + '/dossia-restful-api/services/v3.0' + path ) )
    end

    def post( path, params = nil )
      parse( @access_token.post( DOSSIA_URL + '/dossia-restful-api/services/v3.0' + path, params ) )
    end

    def put( path, params = nil )
      parse( @access_token.put( DOSSIA_URL + '/dossia-restful-api/services/v3.0' + path, params ) )
    end

    def record
      @record 
    end

    protected

    def parse( resp )
      Hash.from_xml( resp.body )['container']['document']
    end

  end

end