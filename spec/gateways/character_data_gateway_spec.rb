require 'rails_helper'

# Resource: D&D 5e API (https://www.dnd5eapi.co/)
RSpec.describe CharacterDataGateway do

  describe "GET /api/2014/classes/" do
    it "should make a request to D&D 5e API and return all character classes" do
      VCR.usse_cassette("character_classes") do

        character_classes = CharacterDataGateway.classes

        expect(character_classes).not_to be_empty
        
        # Test char class poro for specific information
      end
    end
  end
end


# https://www.dnd5eapi.co/api/2014/