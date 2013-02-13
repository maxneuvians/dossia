module Dossia
  module Documents

    # Returns a specific application document by ID
    #
    # id  - ID of application document
    #
    def get_application_document( id )
       get_binary '/records/' + @record.id.to_s + '/apps/documents/key/' + id
    end

    # Returns metadata on all application documents
    #
    def get_application_documents_metadata
      Hashie::Mash.new( get('/records/' + @record.id.to_s + '/apps/documents/meta') )['container']['document']
    end

    # Returns a count of all documents in the record
    #
    def get_document_count
      Hashie::Mash.new( get('/records/' + @record.id.to_s + '/documents/summary_count') )['summary']['document']
    end

    # Returns a specific document by ID and version
    #
    # id      - ID of document
    # version - Version of the document
    #
    def get_document_by_id( id, version = nil )
      if version
        Hashie::Mash.new( get('/records/' + @record.id.to_s + '/documents/' + id + '/versions/' + version ) )['container']['document']
      else
        Hashie::Mash.new( get('/records/' + @record.id.to_s + '/documents/' + id ) )['container']['document']
      end
    end

    # Returns a specific document's metadata by ID
    #
    # id  - ID of document
    #
    def get_document_metadata( id, args = nil )
      Hashie::Mash.new( get('/records/' + @record.id.to_s + '/documents/' + id + '/meta', args) )['container']['document']
    end

    # Returns a specific document's parents by ID
    #
    # id  - ID of document
    #
    def get_document_parent( id, args = nil )
      Hashie::Mash.new( get('/records/' + @record.id.to_s + '/documents/' + id + '/parent', args) )['container']['document']
    end

    # Returns a collection of documents
    #
    # type  - Limits collection to a specific type
    # klass - Limits collection to a specific type class
    # args  - Hash of additional arguments to be pased to GET url as query arguments
    #
    # Always returns a collection
    #
    def get_documents( type = nil, klass = nil, args = nil )

      if type and klass
        d = Hashie::Mash.new( get('/records/' + @record.id.to_s + '/documents/document_type/' + type.capitalize + '/class/' + klass.capitalize, args) )['container']['document']
      elsif type
        d = Hashie::Mash.new( get('/records/' + @record.id.to_s + '/documents/document_type/' + type.capitalize, args) )['container']['document']
      else
        d = Hashie::Mash.new( get('/records/' + @record.id.to_s + '/documents/', args) )['container']['document']
      end

      # Turn documents into a collection if the result is only one
      d = Array.new.push d unless d.kind_of? Array
      d

    end

    # Returns metadata on all application documents
    #
    def get_documents_metadata
      Hashie::Mash.new( get('/records/' + @record.id.to_s + '/documents/meta') )['container']['document']
    end

    # Suppresses a specific application document by ID
    #
    # id  - ID of application document
    #
    def suppress_document( id )
      delete('/records/' + @record.id.to_s + '/documents/' + id)
    end

    # Unsuppresses a specific application document by ID
    #
    # id  - ID of application document
    #
    def unsuppress_document( id )
      post('/records/' + @record.id.to_s + '/documents/' + id + '/unsuppress')
    end

  end
end