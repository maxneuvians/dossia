require 'spec_helper'

describe 'Documents' do 

  context ".create_document" do
    
    it 'creates a new document' do 

      pending

    end 

  end

  context ".get_documents" do

    it 'returns an array of the document tree' do
      VCR.use_cassette('document_tree') do
        documents = Dossia.new.get_documents
        documents.should be_a Array
      end
    end

    it 'returns an array of the document tree with GET arguments' do
      VCR.use_cassette('document_tree_limit_one') do
        documents = Dossia.new.get_documents(nil, nil, { :limit => 1 } )
        documents.should be_a Array
        documents.length.should eql 1
      end
    end

    it 'returns an array of problem documents' do
      VCR.use_cassette('problems') do
        documents = Dossia.new.get_documents('Problem')
        documents.should be_a Array
      end
    end

    it 'returns a not found error if type is invalid' do
      VCR.use_cassette('invalid') do
        proc { Dossia.new.get_documents('ZorkWidget+++') }.
          should raise_error Dossia::NotFoundError, "Resource not found"
      end
    end

    it 'capitalizes missing parameters' do 
      VCR.use_cassette('capitalize_documents_call') do
        documents = Dossia.new.get_measurement_documents_by_weight
        documents.should be_a Array
      end
    end

  end

  context ".get_document_count" do
    
    it 'returns an array of document counts' do
      VCR.use_cassette('document_count') do
        documents = Dossia.new.get_document_count
        documents.should be_a Array
      end
    end

  end

  context ".get_document_by_id" do
    
    it 'returns a Hashie::Mash of a particular document' do
      VCR.use_cassette('document_by_id') do

        documents = Dossia.new.get_documents
        id = documents.first.id

        document = Dossia.new.get_document_by_id( id )
        document.should be_a Hashie::Mash
        document.id.should eql id

      end
    end

    it 'returns a Hashie::Mash of a particular document and version' do
      VCR.use_cassette('document_by_id_and_version') do

        documents = Dossia.new.get_documents
        id = documents.first.id
        version = documents.first.version

        document = Dossia.new.get_document_by_id( id, version )
        document.should be_a Hashie::Mash
        document.id.should eql id
        document.version.should eql version

      end
    end

  end

  context ".get_document_metadata" do
    
    it 'returns a Hashie::Mash of a particular document metadata' do
      VCR.use_cassette('document_metadata') do

        documents = Dossia.new.get_documents
        id = documents.first.id

        document = Dossia.new.get_document_metadata( id )
        document.should be_a Hashie::Mash

      end
    end

  end

  context ".get_document_parent" do
    
    it 'returns a Hashie::Mash of a particular document parent' do
      pending
    end

  end

  context ".get_documents_metadata" do
    
    it 'returns an Array of a all documents metadata' do
      VCR.use_cassette('documents_metadata') do
        documents = Dossia.new.get_documents_metadata
        documents.should be_a Array
      end
    end

  end

  context ".get_application_document" do

    it 'returns a particular application document' do
      VCR.use_cassette('application_document') do

        documents = Dossia.new.get_application_documents_metadata
        id = documents.first.id

        response = Dossia.new.get_application_document( id )
        response.code.to_i.should eql 200

      end
    end

  end

  context ".get_application_documents_metadata" do

    it 'returns an Array of a all application documents metadata' do
      VCR.use_cassette('application_documents_metadata') do
        documents = Dossia.new.get_application_documents_metadata
        documents.should be_a Array
      end
    end

  end

  context ".suppress_document" do
    
    it "suppress' a document by ID" do 

      VCR.use_cassette('suppress_document_by_id') do

        documents = Dossia.new.get_documents
        id = documents.first.id

        response = Dossia.new.suppress_document( id )
        response.code.to_i.should eql 200
        response.body.should include id

        proc { documents = Dossia.new.get_document_by_id( id ) }.
          should raise_error Dossia::NotFoundError, "Resource not found"

      end

    end

  end

  context ".unsuppress_document" do
    
    it "unsuppress' a document by ID" do 

      VCR.use_cassette('unsuppress_document_by_id') do

        documents = Dossia.new.get_documents
        id = documents.first.id

        response = Dossia.new.suppress_document( id )
        response.code.to_i.should eql 200
        response.body.should include id

        proc { documents = Dossia.new.get_document_by_id( id ) }.
          should raise_error Dossia::NotFoundError, "Resource not found"

        response = Dossia.new.unsuppress_document( id )
        response.code.to_i.should eql 200
        response.body.should include id

        document = Dossia.new.get_document_by_id( id )
        document.should be_a Hashie::Mash
        document.id.should eql id
          
      end

    end

  end 

end