require 'spec_helper'

describe 'Documents' do 

  context ".get_documents" do

    it 'returns an array of the document tree' do
      VCR.use_cassette('document_tree') do
        documents = Dossia.new.get_documents
        documents.should be_a Array
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

  context ".get_documents_metadata" do
    
    it 'returns an Array of a all documents metadata' do
      VCR.use_cassette('documents_metadata') do
        document = Dossia.new.get_documents_metadata
        document.should be_a Array
      end
    end

  end

end