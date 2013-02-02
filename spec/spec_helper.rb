$:.unshift File.expand_path("../..", __FILE__)

require 'simplecov'
SimpleCov.start do
  add_group 'Dossia', 'lib/dossia'
end

require 'webmock/rspec'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.ignore_localhost = true
  c.allow_http_connections_when_no_cassette = true
  c.configure_rspec_metadata!

  c.before_record do |i|
    i.request.headers["Authorization"] = nil
  end

end

require 'config'
require 'dossia'