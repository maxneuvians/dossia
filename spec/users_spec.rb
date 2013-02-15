require 'spec_helper'

describe 'Users' do 

  context ".user" do

    it 'returns a Hashie::Mash of user information' do
      VCR.use_cassette('record') do
        user = Dossia.new.user
        user.should be_a Hashie::Mash
        user.FullName.should be_true
        user.FirstName.should be_true
        user.LastName.should be_true
        user.DateOfBirth.should be_true
        user.Gender.should be_true
        user.Contact.should be_true
      end
    end

  end

end