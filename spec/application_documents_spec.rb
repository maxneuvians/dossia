require 'spec_helper'

describe 'ApplicationDocuments' do 

  let(:client){ Dossia.new }

  context ".create_application_document" do

    it 'creates a new application document' do
      VCR.use_cassette('create_application_document') do

        id        = 'Test__Foo__Bar'
        document  = '{"foo":"bar"}'
        type      = 'application/json'

        document = client.create_application_document( id, type, document )
        document['id'].should eql id

      end
    end

  end

  context ".delete_application_document" do

    it 'creates a new application document' do
      VCR.use_cassette('delete_application_document') do

        id        = 'Test__Foo__Bar__Delete'
        document  = '{"foo":"bar"}'
        type      = 'application/json'

        document = client.create_application_document( id, type, document )
        resp = client.delete_application_document( id )
        resp.body.should include 'App Content deleted'

      end
    end

  end

  context ".get_application_document" do

    it 'returns a particular application document' do
      VCR.use_cassette('application_document') do

        documents = client.get_application_documents_metadata
        id = documents.first['id']

        response = client.get_application_document( id )
        response.code.to_i.should eql 200

      end
    end

  end

  context ".get_application_documents_metadata" do

    it 'returns an Nokogiri::XML::NodeSet of a all application documents metadata' do
      VCR.use_cassette('application_documents_metadata') do
        documents = client.get_application_documents_metadata
        documents.should be_a Nokogiri::XML::NodeSet
      end
    end

  end

  context ".replace_application_document" do

    it 'replaces an existing application document' do
      VCR.use_cassette('replace_application_document') do

        id        = 'Test__Foo__Bar__Replace'
        document  = '{"foo":"bar"}'
        type      = 'application/json'

        original  = client.create_application_document( id, type, document )

        document  = '{"faz":"baz"}'

        replaced  = client.replace_application_document( id, type, document )

        document  = client.get_application_document( id )

        original['id'].should eql replaced['id']
        replaced['id'].should eql id
        document.faz.should eql 'baz'

      end
    end

  end

end