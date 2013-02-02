require 'spec_helper'

describe 'Documents' do 

  context ".get_problems" do

    it 'returns a Hashie::Mash of problem documents' do
      VCR.use_cassette('problems') do
        documents = Dossia.new.get_problems
        puts documents
      end
    end

  end

end