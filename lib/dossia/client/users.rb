module Dossia
  module Users

    def user
      Hashie::Mash.new( Hash.from_xml( @record.xpath('//phr:Participant').first.to_xml ) ).Participant 
    end

  end
end