module Dossia
  module Documents

    # Attaches a new binary file to a document
    #
    # parent  - Parent that binary file is attached to
    # type    - Content type for binary file
    # payload - Content to be inserted into binary file 
    #
    def attach_binary( parent, type, payload)

      if !parent.kind_of? String
        parent = parent['id']
      end

      post_binary( '/records/' + @record_id + '/documents/' + parent + '/binary', type, payload ).xpath('//api:document').first

    end

    # Creates a new document
    #
    # payload - Payload object that contains XML (either string or object)
    # parent  - Optional Parent ID (either Nokogiri object or string) 
    #
    def create_document( payload, parent = nil )
      
      if !payload.kind_of? String
        payload = payload.to_xml
      end

      if parent and !parent.kind_of? String
        parent = parent['id']
      end

      if parent
        post( '/records/' + @record_id + '/documents/' + parent + '/rels/related', payload ).xpath('//api:document').first
      else 
        post( '/records/' + @record_id + '/documents', payload ).xpath('//api:document').first
      end
    end

    # Returns a count of all documents in the record
    #
    def get_document_count
      get('/records/' + @record_id + '/documents/summary_count').xpath('//api:document')
    end

    # Returns a specific document by ID and version
    #
    # id      - ID of document
    # version - Version of the document
    #
    def get_document_by_id( id, version = nil )
      if version
        get( '/records/' + @record_id + '/documents/' + id + '/versions/' + version ).xpath('//api:document').first
      else
        get( '/records/' + @record_id + '/documents/' + id ).xpath('//api:document').first
      end
    end

    # Returns a specific document's metadata by ID
    #
    # id  - ID of document
    #
    def get_document_metadata( id, args = nil )
      get( '/records/' + @record_id + '/documents/' + id + '/meta', args ).xpath('//api:document').first
    end

    # Returns a specific document's parents by ID
    #
    # id  - ID of document
    #
    def get_document_parents( id, args = nil )
      get( '/records/' + @record_id + '/documents/' + id + '/parent', args ).xpath('//api:document')
    end

    # Returns a specific document's versions by ID
    #
    # id  - ID of document
    #
    def get_document_versions( id )
      get( '/records/' + @record_id + '/documents/' + id + '/versions' ).xpath('//api:document')
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
        get( '/records/' + @record_id + '/documents/document_type/' + type.capitalize + '/class/' + klass.capitalize, args).xpath('//api:document')
      elsif type
        get( '/records/' + @record_id + '/documents/document_type/' + type.capitalize, args ).xpath('//api:document')
      else
        get( '/records/' + @record_id + '/documents/', args ).xpath('//api:document')
      end

    end

    # Returns metadata on all application documents
    #
    def get_documents_metadata
      get( '/records/' + @record_id + '/documents/meta' ).xpath('//api:document')
    end

    # Relates two existing documents to each other by ID
    #
    # parent  - ID of parent document (can be Nokogiri object)
    # child   - ID of child document (can be Nokogiri object)
    def relate_documents( parent, child )

      if !parent.kind_of? String
        parent = parent['id']
      end

      if !child.kind_of? String
        child = child['id']
      end

      get '/records/' + @record_id + '/documents/' + parent + '/rels/related/' + child

    end

    # Accepts XML and replaces an existing Document
    #
    # to_replace  - ID of document to be replaced (can be a Nokogiri object)
    # payload     - Payload object that contains XML (either string or object) 
    #
    def replace_document( to_replace, payload )
      
      if !to_replace.kind_of? String
        to_replace = to_replace['id']
      end

      if !payload.kind_of? String
        payload = payload.to_xml
      end

      post( '/records/' + @record_id + '/documents/' + to_replace + '/replace', payload ).xpath('//api:document').first
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