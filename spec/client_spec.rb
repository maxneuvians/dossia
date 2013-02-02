require 'spec_helper'

describe 'Client' do 

  it 'raises ConfigurationError on invalid config parameter' do
    proc { Dossia::Client.new( {} ) }.
      should raise_error Dossia::ConfigurationError, "Client needs to be configured"
  end

  it 'raises ConfigurationError on invalid config parameter' do

    proc { Dossia::Client.new(nil) }.
      should raise_error Dossia::ConfigurationError, "Options hash required"

    proc { Dossia::Client.new('FOOBAR') }.
      should raise_error Dossia::ConfigurationError, "Options hash required"

  end

  it 'create a valid OAuth client' do 
    Dossia.new.access_token.should be_a OAuth::AccessToken
  end

  it 'creates a valid OAuth client with passed params' do 
    Dossia.new( :oauth_token => ENV['DOSSIA_OAUTH_TOKEN'], :oauth_token_secret => ENV['DOSSIA_OAUTH_TOKEN_SECRET']).access_token.should be_a OAuth::AccessToken
  end

  it 'creates a valid OAuth client with passed request token' do 
    #Dossia.new( :request_token => '' ).access_token.should be_a OAuth::AccessToken
  end

  it 'responds with a user ID' do 
    VCR.use_cassette('record') do
      Dossia.new.record.id?.should be_true
    end
  end

end 