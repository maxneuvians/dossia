module Dossia
  module Users

    # Returns a Hashie::Mash of the user who the cients records belongs to
    #
    def user
      Hashie::Mash.new( Hash.from_xml( @record.xpath('//phr:Participant').first.to_xml ) ).Participant 
    end

  end
end