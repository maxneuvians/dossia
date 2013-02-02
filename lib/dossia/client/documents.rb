module Dossia
  module Documents

    def get_problems( args = nil )
      Hashie::Mash.new get('/records/' + @record.id.to_s + '/documents/document_type/Problem', args)
    end

  end
end