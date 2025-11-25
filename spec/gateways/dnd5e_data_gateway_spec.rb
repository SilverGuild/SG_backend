require 'rails_helper'

# Resource: D&D 5e API (https://www.dnd5eapi.co/)
RSpec.describe Dnd5eDataGateway do
  describe "GET /api/2014/classes/" do
    it "should make a request to D&D 5e API and return all character classes" do
      VCR.use_cassette("character_classes") do
        character_classes = Dnd5eDataGateway.fetch_character_classes

        expect(character_classes).not_to be_empty
        expect(character_classes.count).to eq(12)
        expect(character_classes.first[:index]).to eq("barbarian")
        expect(character_classes.last[:index]).to eq("wizard")
      end
    end

     it "should make a request to D&D 5e API and return a single character class by id" do
      VCR.use_cassette("single_character_class_sorcerer") do
        character_class = Dnd5eDataGateway.fetch_character_classes("sorcerer")

        expect(character_class).not_to be_empty
        expect(character_class[:index]).to eq("sorcerer")
      end
    end
  end

  describe "GET /api/2014/subclasses" do
    it "should make a request to D&D 5e API and return all subclasses" do
      VCR.use_cassette("character_subclasses") do
        character_subclasses = Dnd5eDataGateway.fetch_subclasses

        expect(character_subclasses).not_to be_empty
        expect(character_subclasses.count).to eq(12)
        expect(character_subclasses.first[:index]).to eq("berserker")
        expect(character_subclasses.last[:index]).to eq("thief")
      end
    end

    it "should make a request to D&D 5e API and return a single subclass" do
      VCR.use_cassette("character_subclass_lore") do
        character_subclass = Dnd5eDataGateway.fetch_subclasses("lore")

        expect(character_subclass).not_to be_empty
        expect(character_subclass[:index]).to eq("lore")
      end
    end
  end

  describe "GET /api/2014/races/" do
    it "should make a request to D&D 5e API and return all character races" do
      VCR.use_cassette("character_races") do
        character_races = Dnd5eDataGateway.fetch_races

        expect(character_races).not_to be_empty
        expect(character_races.count).to eq(9)
        expect(character_races.first[:index]).to eq("dragonborn")
        expect(character_races.last[:index]).to eq("tiefling")
      end
    end

    it "should make a request to D&D 5e API and return a single character race by id" do
      VCR.use_cassette("single_character_race_halfling") do
        target_id = "halfling"
        character_race = Dnd5eDataGateway.fetch_races(target_id)

        expect(character_race).not_to be_empty

        expect(character_race[:index]).to eq(target_id)
      end
    end
  end

  describe "GET /api/2014/subraces" do
    it "should make a request to D&D 5e API and return all subraces" do
      VCR.use_cassette("character_subraces") do
        character_subraces = Dnd5eDataGateway.fetch_subraces

        expect(character_subraces).not_to be_empty
        expect(character_subraces.count).to eq(4)
        expect(character_subraces.first[:index]).to eq("high-elf")
        expect(character_subraces.last[:index]).to eq("rock-gnome")
      end
    end

    it "should make a request to D&D 5e API and return a single subrace" do
      VCR.use_cassette("character_subrace_lightfoot_halfling") do
        character_subrace = Dnd5eDataGateway.fetch_subraces("lightfoot-halfling")

        expect(character_subrace).not_to be_empty
        expect(character_subrace[:index]).to eq("lightfoot-halfling")
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
