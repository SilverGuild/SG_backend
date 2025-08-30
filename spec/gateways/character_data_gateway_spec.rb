require 'rails_helper'

# Resource: D&D 5e API (https://www.dnd5eapi.co/)
RSpec.describe CharacterDataGateway do

  describe "GET /api/2014/classes/" do
    it "should make a request to D&D 5e API and return all character classes" do
      VCR.use_cassette("character_classes") do

        character_classes = CharacterDataGateway.fetch_classes

        expect(character_classes).not_to be_empty
        expect(character_classes.count).to eq(12)
        expect(character_classes.first[:index]).to eq("barbarian")
        expect(character_classes.last[:index]).to eq("wizard")
      end
    end
  end
end
