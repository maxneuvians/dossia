require 'spec_helper'

describe 'Utils' do 

  let(:client){ Dossia.new }

  context ".scrub_document" do 

    it 'removes unique identification attributes from a document' do

      VCR.use_cassette('test_scrub_document') do

        document  = client.get_documents(nil, nil, { :limit => 1 } ).first        
        document  = client.scrub_document( document )

        document['id'].should eql nil
        document.namespace.should eql nil
        document['type'].should eql nil
        document['version'].should eql nil
        document['xsi:schemaLocation'].should eql nil

      end

    end

    it 'removes unique identification attributes from a document' do

      VCR.use_cassette('test_scrub_documents') do

        documents  = client.get_documents(nil, nil, { :limit => 2 } )        
        documents  = client.scrub_document( documents )

        documents.each do |document|
          document['id'].should eql nil
          document.namespace.should eql nil
          document['type'].should eql nil
          document['version'].should eql nil
          document['xsi:schemaLocation'].should eql nil

        end

      end

    end

    it 'only allowes Nokogiri NodeSet or Element as an argument' do 

      proc{ client.scrub_document( Array.new ) }.
        should raise_error Dossia::BadArgumentError, 'This method expects a Nokogiri NodeSet or Element'

    end

  end

  context ".wrap_container" do 

    it 'wraps a document in a Dossia API friendly XML container' do

      VCR.use_cassette('test_document_wrap_container') do

        document  = client.get_documents(nil, nil, { :limit => 1 } ).first        
        document  = client.wrap_container( document )

        document.root.name.should eql 'container'
        document.xpath('//api:document', 'api' => 'http://www.dossia.org/v2.0/api').length.should eql 1

      end

    end

    it 'wraps a document in a Dossia API friendly XML container' do

      VCR.use_cassette('test_documents_wrap_container') do

        documents  = client.get_documents(nil, nil, { :limit => 2 } )        
        documents  = client.wrap_container( documents )

        documents.root.name.should eql 'container'
        documents.xpath('//api:document', 'api' => 'http://www.dossia.org/v2.0/api').length.should eql 2

      end

    end

    it 'only allowes Nokogiri NodeSet or Element as an argument' do 

      proc{ client.wrap_container( Array.new ) }.
        should raise_error Dossia::BadArgumentError, 'This method expects a Nokogiri NodeSet or Element'

    end

  end

end