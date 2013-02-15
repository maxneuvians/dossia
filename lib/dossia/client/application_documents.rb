module Dossia
  module ApplicationDocuments

    # Creates a new application document
    #
    # id      - ID of application document
    # type    - Content type for application document
    # payload - Content to be inserted into application document
    #
    def create_application_document( id, type, payload )
      post_binary( '/records/' + @record_id + '/apps/documents/key/' + id, type, payload ).xpath('//api:document').first
    end

    # Deletes a specific application document by ID
    #
    # id  - ID of application document
    #
    def delete_application_document( id )
      delete '/records/' + @record_id + '/apps/documents/key/' + id
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
      get( '/records/' + @record_id + '/apps/documents/meta' ).xpath('//api:document')
    end

    # Replaces an existing application document
    #
    # id      - ID of application document
    # type    - Content type for application document
    # payload - Content to be inserted into application document
    #
    def replace_application_document( id, type, payload )
      post_binary( '/records/' + @record_id + '/apps/documents/key/' + id + '/replace', type, payload ).xpath('//api:document').first
    end

  end
end