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
    pending
    #Dossia.new( :request_token => '' ).access_token.should be_a OAuth::AccessToken
  end

  it 'responds with a user ID' do 
    VCR.use_cassette('record') do
      Dossia.new.record.id?.should be_true
    end
  end

  it 'returns an Array for a valid missing method call' do
    VCR.use_cassette('method_missing_problems') do
        documents = Dossia.new.get_Problem_documents
        documents.should be_a Array
    end
  end

  it 'raises an error for an invalid missing method call' do
    VCR.use_cassette('bad_method_missing') do
        proc { documents = Dossia.new.get__documents }.
          should raise_error NoMethodError
    end
  end

  it 'raises an error for an unkown missing method call' do
    VCR.use_cassette('unkown_method_missing') do
        proc { documents = Dossia.new.get_ZORK_documents }.
          should raise_error Dossia::NotFoundError, "Resource not found"
    end
  end

  it 'returns a not found error if type is invalid' do
    VCR.use_cassette('invalid') do
      proc { Dossia.new.get_documents('ZorkWidget+++') }.
        should raise_error Dossia::NotFoundError, "Resource not found"
    end
  end

  it 'returns a bad request error if type is invalid' do
    pending 
  end

  it 'returns a valid binary document' do
    pending
  end

end 