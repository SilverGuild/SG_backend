require "rails_helper"

RSpec.describe "Character Class PORO" do
  describe "happy paths" do
    it "should create a new character class poro with all attributes accessible" do
      VCR.use_cassette("monk_class") do
        response = Faraday.get("https://www.dnd5eapi.co/api/2014/classes/monk")
        test_response = JSON.parse(response.body, symbolize_names: true)

        monk = CharacterClassPoro.new(test_response)

        expect(monk).to be_an_instance_of CharacterClassPoro
        expect(monk.name).to eq("Monk")
        expect(monk.url).to eq("/api/2014/classes/monk")
        expect(monk.hit_die).to eq(8)
        expect(monk.skill_proficiencies.length).to eq(2)
        expect(monk.skill_proficiencies[:choose]).to eq(2)
        expect(monk.skill_proficiencies[:skills]).to eq([ "acrobatics", "athletics", "history", "insight", "religion", "stealth" ])
        expect(monk.saving_throw_proficiencies).to eq([ "str", "dex" ])      
      end
    end
  end
end
