module Dossia
  module Documents

    def create_document( payload )

    end

    # Returns a specific application document by ID
    #
    # id  - ID of application document
    #
    def get_application_document( id )
       get_binary '/records/' + @record_id + '/apps/documents/key/' + id
    end

    # Returns metadata on all application documents
    #
    def get_application_documents_metadata
      get '/records/' + @record_id + '/apps/documents/meta' 
    end

    # Returns a count of all documents in the record
    #
    def get_document_count
      get '/records/' + @record_id + '/documents/summary_count'
    end

    # Returns a specific document by ID and version
    #
    # id      - ID of document
    # version - Version of the document
    #
    def get_document_by_id( id, version = nil )
      if version
        get '/records/' + @record_id + '/documents/' + id + '/versions/' + version 
      else
        get '/records/' + @record_id + '/documents/' + id 
      end
    end

    # Returns a specific document's metadata by ID
    #
    # id  - ID of document
    #
    def get_document_metadata( id, args = nil )
      get( '/records/' + @record_id + '/documents/' + id + '/meta', args )
    end

    # Returns a specific document's parents by ID
    #
    # id  - ID of document
    #
    def get_document_parent( id, args = nil )
      get( '/records/' + @record_id + '/documents/' + id + '/parent', args )
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
        get( '/records/' + @record_id + '/documents/document_type/' + type.capitalize + '/class/' + klass.capitalize, args) 
      elsif type
        get( '/records/' + @record_id + '/documents/document_type/' + type.capitalize, args )
      else
        get( '/records/' + @record_id + '/documents/', args )
      end

    end

    # Returns metadata on all application documents
    #
    def get_documents_metadata
      get '/records/' + @record_id + '/documents/meta' 
    end

    # Suppresses a specific application document by ID
    #
    # id  - ID of application document
    #
    def suppress_document( id )
      delete '/records/' + @record_id + '/documents/' + id 
    end

    # Unsuppresses a specific application document by ID
    #
    # id  - ID of application document
    #
    def unsuppress_document( id )
      post '/records/' + @record_id + '/documents/' + id + '/unsuppress' 
    end

  end
end