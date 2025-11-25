require "rails_helper"

RSpec.describe "Race PORO" do
  describe "happy paths" do
    it "should create a new race poro with all attributes accessible" do
        VCR.use_cassette("race_poro_human") do
            response = Faraday.get("https://www.dnd5eapi.co/api/2014/races/human")
            test_response = JSON.parse(response.body, symbolize_names: true)

            human = RacePoro.new(test_response)

            expect(human).to be_an_instance_of RacePoro
            expect(human.id).to eq("human")
            expect(human.name).to eq("Human")
            expect(human.speed).to eq(30)
            expect(human.size).to eq("Medium")
            expect(human.ability_bonuses.first[:ability_score][:index]).to eq("str")
            expect(human.age_description).to eq("Humans reach adulthood in their late teens and live less than a century.")
            expect(human.alignment_description).to eq("Humans tend toward no particular alignment. The best and the worst are found among them.")
            expect(human.size_description).to eq("Humans vary widely in height and build, from barely 5 feet to well over 6 feet tall. Regardless of your position in that range, your size is Medium.")
            expect(human.language_description).to eq("You can speak, read, and write Common and one extra language of your choice. Humans typically learn the languages of other peoples they deal with, including obscure dialects. They are fond of sprinkling their speech with words borrowed from other tongues: Orc curses, Elvish musical expressions, Dwarvish military phrases, and so on.")
            expect(human.languages.first[:index]).to eq("common")
        end
    end
  end
end
