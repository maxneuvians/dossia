require 'dossia/version'
require 'dossia/error'
require 'dossia/client'

module Dossia

  @@options = {}

  # Create a new Client instance
  #
  def self.new( options = {} )

    self.configure {} if ENV['DOSSIA_CONSUMER_KEY'] and ENV['DOSSIA_CONSUMER_SECRET'] and ENV['DOSSIA_OAUTH_TOKEN'] and ENV['DOSSIA_OAUTH_TOKEN_SECRET']
    Dossia::Client.new( options )

  end

  # Define Oauth Configuration
  #
  # options[ :consumer_key ]        - API OAuth Consumer Key
  # options[ :consumer_secret ]     - API OAuth Consumer Secret 
  # options[ :oauth_token ]         - API OAuth User Key
  # options[ :oauth_token_secret ]  - API OAuth User Secret 
  #
  def self.configure( options = {} )

    unless options.kind_of? Hash
      raise Dossia::ConfigurationError, "Options hash required"
    end 

    @@options[ :consumer_key ]        = options[ :consumer_key ] || ENV['DOSSIA_CONSUMER_KEY']
    @@options[ :consumer_secret ]     = options[ :consumer_secret ] || ENV['DOSSIA_CONSUMER_SECRET']
    @@options[ :oauth_token ]         = options[ :oauth_token ] || ENV['DOSSIA_OAUTH_TOKEN']
    @@options[ :oauth_token_secret ]  = options[ :oauth_token_secret ] || ENV['DOSSIA_OAUTH_TOKEN_SECRET']
    @@options

  end

  # Return global configuration hash
  #
  def self.configuration
    @@options
  end

  # Reset global configuration
  #
  def self.reset_configuration
    @@options = {}
  end

end