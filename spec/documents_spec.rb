require 'spec_helper'

describe 'Documents' do 

  let(:client){ Dossia.new }

  context ".attach_binary" do
    
    it 'attaches a binary file to a document' do
      pending
    end

  end

  context ".create_document" do
    
    it 'creates a new document with Document object' do 
      VCR.use_cassette('create_document') do
        document  = client.get_documents(nil, nil, { :limit => 1 } ).first

        document.at( '//phr:Date/phr:StartDate', 'phr' => 'http://www.dossia.org/v2.0/xml/phr' ).content = Date.today.strftime('%Y-%m-%d')
        
        document = client.scrub_document( document )
        document = client.wrap_container( document )

        document = client.create_document( document )
        document['id'].should be_true
      end
    end

    it 'creates a new document with XML string' do 
      VCR.use_cassette('create_document_xml_string') do
        document  = client.get_documents(nil, nil, { :limit => 1 } ).first

        document.at( '//phr:Date/phr:StartDate', 'phr' => 'http://www.dossia.org/v2.0/xml/phr' ).content = Date.today.strftime('%Y-%m-%d')
        
        document = client.scrub_document( document )
        document = client.wrap_container( document )

        document = client.create_document( document.to_xml )
        document['id'].should be_true
      end
    end 

    it 'creates a new document with XML string and relates it to parent' do 
      VCR.use_cassette('create_document_xml_string_and_parent') do
        documents  = client.get_documents(nil, nil, { :limit => 2 } )

        parent  = documents.first
        child   = documents.last
        
        child = client.scrub_document( child )
        child = client.wrap_container( child )

        document = client.create_document( child.to_xml, parent )
        document['id'].should be_true
      end
    end

  end

  context ".get_documents" do

    it 'returns a Nokogiri::XML::NodeSet of the document tree' do
      VCR.use_cassette('document_tree') do
        documents = client.get_documents
        documents.should be_a Nokogiri::XML::NodeSet
      end
    end

    it 'returns a Nokogiri::XML::NodeSet of the document tree with GET arguments' do
      VCR.use_cassette('document_tree_limit_one') do
        documents = client.get_documents(nil, nil, { :limit => 1 } )
        documents.should be_a Nokogiri::XML::NodeSet
        documents.length.should eql 1
      end
    end

    it 'returns a Nokogiri::XML::NodeSet of problem documents' do
      VCR.use_cassette('problems') do
        documents = client.get_documents('Problem')
        documents.should be_a Nokogiri::XML::NodeSet
      end
    end

    it 'returns a not found error if type is invalid' do
      VCR.use_cassette('invalid') do
        proc { client.get_documents('ZorkWidget+++') }.
          should raise_error Dossia::NotFoundError
      end
    end

    it 'capitalizes missing parameters' do 
      VCR.use_cassette('capitalize_documents_call') do
        documents = client.get_measurement_documents_by_weight
        documents.should be_a Nokogiri::XML::NodeSet
      end
    end

  end

  context ".get_document_count" do
    
    it 'returns a Nokogiri::XML::NodeSet of document counts' do
      VCR.use_cassette('document_count') do
        documents = client.get_document_count
        documents.should be_a Nokogiri::XML::NodeSet
      end
    end

  end

  context ".get_document_by_id" do
    
    it 'returns a Nokogiri::XML::Element of a particular document' do
      VCR.use_cassette('document_by_id') do

        documents = client.get_documents
        id = documents.first['id']

        document = client.get_document_by_id( id )
        document.should be_a Nokogiri::XML::Element
        document['id'].should eql id

      end
    end

    it 'returns a Nokogiri::XML::Element of a particular document and version' do
      VCR.use_cassette('document_by_id_and_version') do

        documents = client.get_documents
        id = documents.first['id']
        version = documents.first['version']

        document = client.get_document_by_id( id, version )
        document.should be_a Nokogiri::XML::Element
        document['id'].should eql id
        document['version'].should eql version

      end
    end

  end

  context ".get_document_metadata" do
    
    it 'returns a Nokogiri::XML::Element of a particular document metadata' do
      VCR.use_cassette('document_metadata') do

        documents = client.get_documents
        id = documents.first['id']

        document = client.get_document_metadata( id )
        document.should be_a Nokogiri::XML::Element

      end
    end

  end

  context ".get_document_parent" do
    
    it 'returns a Nokogiri::XML::NodeSet of a particular document parents' do
      VCR.use_cassette('document_parents') do
        documents  = client.get_documents(nil, nil, { :limit => 2 } )

        parent  = documents.first
        child   = documents.last
        
        child = client.scrub_document( child )
        child = client.wrap_container( child )

        document = client.create_document( child.to_xml, parent )
        document['id'].should be_true

        parents = client.get_document_parents( document['id'] )
        parents.first['id'].should eql parent['id']
        parents.should be_a Nokogiri::XML::NodeSet

      end
    end

  end

  context ".get_document_versions" do
    
    it "returns a Nokogiri::XML::NodeSet of a particular document's versions" do
      VCR.use_cassette('document_versions') do

        documents = client.get_documents(nil, nil, { :limit => 1 })
        id = documents.first['id']

        document = client.get_document_versions( id )
        document.should be_a Nokogiri::XML::NodeSet

      end
    end

  end

  context ".get_documents_metadata" do
    
    it 'returns an Nokogiri::XML::NodeSet of a all documents metadata' do
      VCR.use_cassette('documents_metadata') do
        documents = client.get_documents_metadata
        documents.should be_a Nokogiri::XML::NodeSet
      end
    end

  end

  context ".relate_documents" do
    
    it 'relates two documents by document objects' do 
      VCR.use_cassette('relate_documents') do
        documents  = client.get_documents(nil, nil, { :limit => 2 } )

        parent  = documents.first
        child   = documents.last

        resp = client.relate_documents( parent, child )
        pending
      end
    end

    it 'relates two documents by parent id string and child object' do 
      VCR.use_cassette('relate_documents') do
        documents  = client.get_documents(nil, nil, { :limit => 2 } )

        parent  = documents.first
        child   = documents.last

        resp = client.relate_documents( parent['id'], child )
        pending
      end
    end

    it 'relates two documents by parent object and child id string' do 
      VCR.use_cassette('relate_documents') do
        documents  = client.get_documents(nil, nil, { :limit => 2 } )

        parent  = documents.first
        child   = documents.last

        resp = client.relate_documents( parent, child['id'] )
        pending
      end
    end

  end

  context ".replace_document" do
    
    it 'replaces an existing document with Document object as id to be replaced' do 
      VCR.use_cassette('replace_document') do
        old_document  = client.get_documents(nil, nil, { :limit => 1 } ).first

        version = old_document['version'].to_i

        old_document.at( '//phr:Date/phr:StartDate', 'phr' => 'http://www.dossia.org/v2.0/xml/phr' ).content = Date.today.strftime('%Y-%m-%d')

        new_document = client.scrub_document( old_document )
        new_document = client.wrap_container( old_document )

        document = client.replace_document( old_document, new_document )
        document['id'].should be_true
        document['version'].should eql (version + 1).to_s
      end
    end

    it 'replaces an existing document with XML string' do 
      VCR.use_cassette('replace_document_xml_string') do
        old_document  = client.get_documents(nil, nil, { :limit => 1 } ).first

        id        = old_document['id']
        version   = old_document['version'].to_i

        old_document.at( '//phr:Date/phr:StartDate', 'phr' => 'http://www.dossia.org/v2.0/xml/phr' ).content = Date.today.strftime('%Y-%m-%d')
        
        new_document = client.scrub_document( old_document )
        new_document = client.wrap_container( old_document )

        document = client.replace_document( old_document, new_document )
        document['id'].should be_true
        document['version'].should eql (version + 1).to_s
      end
    end 

  end

  context ".suppress_document" do
    
    it "suppress' a document by ID" do 

      VCR.use_cassette('suppress_document_by_id') do

        documents = client.get_documents
        id = documents.first['id']

        response = client.suppress_document( id )
        response.code.to_i.should eql 200
        response.body.should include id

        proc { documents = client.get_document_by_id( id ) }.
          should raise_error Dossia::NotFoundError

      end

    end

  end

  context ".unsuppress_document" do
    
    it "unsuppress' a document by ID" do 

      VCR.use_cassette('unsuppress_document_by_id') do

        documents = client.get_documents
        id = documents.first['id']

        response = client.suppress_document( id )
        response.code.to_i.should eql 200
        response.body.should include id

        proc { documents = client.get_document_by_id( id ) }.
          should raise_error Dossia::NotFoundError

        response = client.unsuppress_document( id )
        response.code.to_i.should eql 200
        response.body.should include id

        document = client.get_document_by_id( id )
        document.should be_a Nokogiri::XML::Element
        document['id'].should eql id
          
      end

    end

  end 

end