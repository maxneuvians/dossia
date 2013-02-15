module Dossia
  module Utils

    # Scrubs Dossia documents of unique identifiers, usefull when cloning existing documents
    #
    # payload   - The Document(s) you want to have scrubbed
    #
    def scrub_document( payload )

      raise Dossia::BadArgumentError, 'This method expects a Nokogiri NodeSet or Element' unless payload.class == Nokogiri::XML::NodeSet or payload.class == Nokogiri::XML::Element

      if payload.class == Nokogiri::XML::NodeSet    
        payload.each { |node| node = self.scrub_document( node ) }
      else

        payload.remove_attribute 'id'
        payload.namespace = nil
        payload.remove_attribute 'type'
        payload.remove_attribute 'version'

        #Removes schema locations from documents to avoid being jammed into the container later on
        payload.xpath('//*[@xsi:schemaLocation]').each { |node| node.remove_attribute 'schemaLocation' }

      end

      payload

    end

    # Wraps Dossia documents in an API friendly container for POSTing to the Dossia API
    #
    # payload   - The Document(s) you want to have wrapped
    #
    def wrap_container( payload )

      raise Dossia::BadArgumentError, 'This method expects a Nokogiri NodeSet or Element' unless payload.class == Nokogiri::XML::NodeSet or payload.class == Nokogiri::XML::Element

      builder = Nokogiri::XML::Builder.new do |xml|
      
        xml.container(
          "xmlns" => "http://www.dossia.org/v2.0/api",
          "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", 
          "xsi:schemaLocation" => "http://www.dossia.org/v2.0/api http://www.dossia.org/v2.0/api/container.xsd"
        )

      end

      builder = Nokogiri::XML builder.to_xml

      if payload.class == Nokogiri::XML::NodeSet
        payload.each {|node| builder.xpath('//api:container', 'api' => 'http://www.dossia.org/v2.0/api').first.add_child node }
      else
        builder.xpath('//api:container', 'api' => 'http://www.dossia.org/v2.0/api').first.add_child payload
      end

      builder

    end

  end
end