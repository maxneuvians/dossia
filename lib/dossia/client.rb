require 'dossia/client'
require 'dossia/client/documents'
require 'dossia/client/users'

require 'oauth'
require 'active_support/core_ext'
require 'hashie'
require 'nokogiri'

module Dossia

  class Client

    #Assumes client will be in staging if not specified otherwise
    DOSSIA_URL = ENV['DOSSIA_URL'] || 'https://staging-oauth.dossia.org'

    include Dossia::Documents
    include Dossia::Users

    # Allows read access to the access_token variable
    #
    def access_token
      @access_token
    end

    # Initialize client with OAuth configuration
    #
    # options[ :consumer_key ]        - API OAuth Consumer Key
    # options[ :consumer_secret ]     - API OAuth Consumer Secret 
    # options[ :oauth_token ]         - API OAuth User Key
    # options[ :oauth_token_secret ]  - API OAuth User Secret 
    # options[ :request_token ]       - API OAuth Request token passed by Dossia OpenID 
    #
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

      # Allows for a request token to be used to initialize the OAuth Client
      if options[ :request_token ]
        request_token = OAuth::RequestToken.new(@consumer, options[ :request_token ], '')
        @access_token = request_token.get_access_token
      # Allows a second client to be created with other credentials
      elsif options[ :oauth_token ] and options[ :oauth_token_secret ]
        @access_token = OAuth::AccessToken.new( @consumer, options[ :oauth_token ], options[ :oauth_token_secret ] )
      else
        @access_token = OAuth::AccessToken.new( @consumer, Dossia.configuration[ :oauth_token ], Dossia.configuration[ :oauth_token_secret ] )
      end

      # Initializes the record variable with the Dossia user information
      @record     = get('/records')
      @record_id  = @record.xpath('//api:document').first['id'] 

    end 

    # Defines a pattern of guessing methods for document querying
    #
    # name  - Name of meathod to match
    # args  - Arguments passed to that method
    #
    def method_missing( name, *args )
      pieces = name.to_s.split('_')
      super unless (pieces.length == 3 or pieces.length == 5) and pieces.first == 'get' and pieces[2] == 'documents' and pieces.all? { |p| p.length != 0 }
      pieces.length == 3 ? get_documents( pieces[1], nil, args ) : get_documents( pieces[1], pieces[4], args )

    end

    # Allows the client to initiate a DELETE request
    #
    # path    - Path to use call request on
    # params  - Additional GET params to be appended to URL path 
    #
    def delete( path, params = nil )
      path = "#{path}?#{params.map{|k,v|"#{k}=#{v}"}.join('&')}" if params
      parse( @access_token.delete( DOSSIA_URL + '/dossia-restful-api/services/v3.0' + path ) )
    end

    # Allows the client to initiate a GET request
    #
    # path    - Path to use call request on
    # params  - Additional GET params to be appended to URL path 
    #
    def get( path, params = nil )
      path = "#{path}?#{params.map{|k,v|"#{k}=#{v}"}.join('&')}" if params
      parse( @access_token.get( DOSSIA_URL + '/dossia-restful-api/services/v3.0' + path ) )
    end

    # Allows the client to initiate a GET request that expects a binary stream returned
    #
    # path    - Path to use call request on
    #
    def get_binary( path )
      parse( @access_token.get( DOSSIA_URL + '/dossia-restful-api/services/v3.0' + path ) )
    end

    # Allows the client to initiate a POST request
    #
    # path    - Path to use call request on
    # params  - POST params to be sent with the URL 
    #
    def post( path, params = nil )
      parse( @access_token.post( DOSSIA_URL + '/dossia-restful-api/services/v3.0' + path, params ) )
    end

    # Allows the client to initiate a POST request with binary content
    #
    # path    - Path to use call request on
    # type    - POST body content type
    # length  - POST body length
    # body    - POST body content
    #
    def post_binary( path, type = nil, length = nil, body = nil )
      #parse( @access_token.post( DOSSIA_URL + '/dossia-restful-api/services/v3.0' + path, params ) )
    end

    # Allows the client to initiate a PUT request
    #
    # path    - Path to use call request on
    # params  - PUT params to be sent with the URL 
    #
    def put( path, params = nil )
      parse( @access_token.put( DOSSIA_URL + '/dossia-restful-api/services/v3.0' + path, params ) )
    end

    # Allows read access to the record variable
    #
    def record
      @record 
    end

    protected

    # Verifies the response header code and if:
    # - 200: parses the response from XML to a hash
    # - 400: Raises a bad request error
    # - 404: Raises a not found error
    #
    # resp  - OAuth response object
    #
    def parse( resp )

      case resp.code.to_i

      when 200
        case resp.content_type

        when 'application/xml'
          Nokogiri::XML( resp.body ) 
        when 'application/json'
          Hash.from_json( resp.body )
        else
          resp
        end

      when 400
        raise Dossia::BadRequestError, 'You made an invalid request'

      when 404
        raise Dossia::NotFoundError, "Resource not found"
      
      end
    
    end

  end

end