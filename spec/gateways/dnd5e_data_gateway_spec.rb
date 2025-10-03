require 'rails_helper'

# Resource: D&D 5e API (https://www.dnd5eapi.co/)
RSpec.describe Dnd5eDataGateway do
  describe "GET /api/2014/classes/" do
    it "should make a request to D&D 5e API and return all character classes" do
      VCR.use_cassette("character_classes") do
        character_classes = Dnd5eDataGateway.fetch_dnd_data("classes")

        expect(character_classes).not_to be_empty
        expect(character_classes.count).to eq(12)
        expect(character_classes.first[:index]).to eq("barbarian")
        expect(character_classes.last[:index]).to eq("wizard")
      end
    end
  end

  describe "GET /api/2014/races/" do
    it "should make a request to D&D 5e API and return all character races" do
      VCR.use_cassette("character_races") do
        character_races = Dnd5eDataGateway.fetch_dnd_data("races")

        expect(character_races).not_to be_empty
        expect(character_races.count).to eq(9)
        expect(character_races.first[:index]).to eq("dragonborn")
        expect(character_races.last[:index]).to eq("tiefling")
      end
    end
  end

  describe "GET /api/2014/languages/" do
    it "should make a request to D&D 5e API and return all character races" do
      VCR.use_cassette("languages") do
        languages = Dnd5eDataGateway.fetch_dnd_data("languages")

        expect(languages).not_to be_empty
        expect(languages.count).to eq(16)
        expect(languages.first[:index]).to eq("abyssal")
        expect(languages.last[:index]).to eq("undercommon")
      end
    end
  end
end
