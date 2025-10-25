require "rails_helper"

RSpec.describe "Language PORO" do
  describe "happy paths" do
    it "should create a new language poro with all attributes accessible" do
      VCR.use_cassette("language_poro_goblin") do
        expected_poro = {
          id: "goblin",
          name: "Goblin",
          language_type: "Standard",
          typical_speakers: [ "Goblinoids" ],
          script: "Dwarvish"
        }

        response = Faraday.get("https://www.dnd5eapi.co/api/2014/languages/goblin")
        test_response = JSON.parse(response.body, symbolize_names: true)

        goblin = LanguagePoro.new(test_response)

        expect(goblin).to be_an_instance_of LanguagePoro
        expect(goblin.id).to eq(expected_poro[:id])
        expect(goblin.name).to eq(expected_poro[:name])
        expect(goblin.language_type).to eq(expected_poro[:language_type])
        expect(goblin.typical_speakers).to eq(expected_poro[:typical_speakers])
        expect(goblin.script).to eq(expected_poro[:script])
      end
    end
  end
end
