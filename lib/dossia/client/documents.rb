module Dossia
  module Documents


    def get_document_count
      Hashie::Mash.new( get('/records/' + @record.id.to_s + '/documents/summary_count') )['summary']['document']
    end

    def get_document_by_id( id, args = nil )
      Hashie::Mash.new( get('/records/' + @record.id.to_s + '/documents/' + id, args) )['container']['document']
    end

    def get_document_metadata( id, args = nil )
      Hashie::Mash.new( get('/records/' + @record.id.to_s + '/documents/' + id + '/meta', args) )['container']['document']
    end

    def get_documents( type = nil, args = nil )
      
      if type
        Hashie::Mash.new( get('/records/' + @record.id.to_s + '/documents/document_type/' + type, args) )['container']['document']
      else
        Hashie::Mash.new( get('/records/' + @record.id.to_s + '/documents/', args) )['container']['document']
      end

    end

    def get_documents_metadata
      Hashie::Mash.new( get('/records/' + @record.id.to_s + '/documents/meta') )['container']['document']
    end

  end
end