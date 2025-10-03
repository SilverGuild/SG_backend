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

     it "should make a request to D&D 5e API and return a single character class by id" do
      VCR.use_cassette("single_character_class") do
        character_class = Dnd5eDataGateway.fetch_dnd_data("classes", "sorcerer")

        expect(character_class).not_to be_empty

        expect(character_class[:index]).to eq("sorcerer")
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

    it "should make a request to D&D 5e API and return a single character race by id" do
      VCR.use_cassette("single_character_race") do
        target_id = "halfling"
        character_race = Dnd5eDataGateway.fetch_dnd_data("races", target_id)

        expect(character_race).not_to be_empty

        expect(character_race[:index]).to eq(target_id)
      end
    end
  end

  describe "GET /api/2014/languages/" do
    it "should make a request to D&D 5e API and return all languages" do
      VCR.use_cassette("languages") do
        languages = Dnd5eDataGateway.fetch_dnd_data("languages")

        expect(languages).not_to be_empty
        expect(languages.count).to eq(16)
        expect(languages.first[:index]).to eq("abyssal")
        expect(languages.last[:index]).to eq("undercommon")
      end
    end

     it "should make a request to D&D 5e API and return a single language by id" do
      VCR.use_cassette("single_language") do
        target_id = "celestial"
        language = Dnd5eDataGateway.fetch_dnd_data("languages", target_id)

        expect(language).not_to be_empty

        expect(language[:index]).to eq(target_id)
      end
    end
  end
end
