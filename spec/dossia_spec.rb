require 'spec_helper'

describe 'Dossia' do 

  context ".new" do
    
    it "creates a new client" do
      Dossia.new.should be_a Dossia::Client
    end

  end

  context ".configure" do

    it "sets configuration options" do 

      config = Dossia.configure( :consumer_key => 'FOO', :consumer_secret => 'BAR', :oauth_token => 'FAZ', :oauth_token_secret => 'BAZ' )

      config.should be_a Hash 
      config.should have_key( :consumer_key )
      config.should have_key( :consumer_secret )
      config.should have_key( :oauth_token )
      config.should have_key( :oauth_token_secret )
      config[ :consumer_key ].should eql( "FOO" )
      config[ :consumer_secret ].should eql( "BAR" )
      config[ :oauth_token ].should eql( "FAZ")
      config[ :oauth_token_secret ].should eql( "BAZ")

    end

    it 'allows for ENV variable to be used to create a new configuration' do
      
      config = Dossia.configure

      config.should be_a Hash 
      config.should have_key( :consumer_key )
      config.should have_key( :consumer_secret )
      config.should have_key( :oauth_token )
      config.should have_key( :oauth_token_secret )
      config[ :consumer_key ].should eql( ENV['DOSSIA_CONSUMER_KEY'] )
      config[ :consumer_secret ].should eql( ENV['DOSSIA_CONSUMER_SECRET'] )
      config[ :oauth_token ].should eql( ENV['DOSSIA_OAUTH_TOKEN'] )
      config[ :oauth_token_secret ].should eql( ENV['DOSSIA_OAUTH_TOKEN_SECRET'] )

    end

    it 'raises ConfigurationError on invalid config parameter' do

      proc { Dossia.configure(nil) }.
        should raise_error Dossia::ConfigurationError, "Options hash required"

      proc { Dossia.configure('FOOBAR') }.
        should raise_error Dossia::ConfigurationError, "Options hash required"

    end
    
  end

  context ".configuration" do

    before do 
        Dossia.configure( :consumer_key => 'FOO', :consumer_secret => 'BAR', :oauth_token => 'FAZ', :oauth_token_secret => 'BAZ' )
      end

      it 'returns global configuration options' do

        config = Dossia.configuration

        config.should have_key( :consumer_key )
      config.should have_key( :consumer_secret )
      config.should have_key( :oauth_token )
      config.should have_key( :oauth_token_secret )
      config[ :consumer_key ].should eql( "FOO" )
      config[ :consumer_secret ].should eql( "BAR" )
      config[ :oauth_token ].should eql( "FAZ")
      config[ :oauth_token_secret ].should eql( "BAZ")

      end

  end

  context ".reset_configuration" do

    before do 
        Dossia.configure( :consumer_key => 'FOO', :consumer_secret => 'BAR', :oauth_token => 'FAZ', :oauth_token_secret => 'BAZ' )
      end

      it 'resets the configuration options' do

        Dossia.reset_configuration
        Dossia.configuration.should eql( Hash.new )

      end
    
  end

end