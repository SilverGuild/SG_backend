require "rails_helper"

RSpec.describe "Race PORO" do
  describe "happy paths" do
    it "should create a new race poro with all attributes accessible" do
        VCR.use_cassette("race_poro_human") do
            expected_poro = {
                id: "human",
                name: "Human",
                description: "He's simple but reliable",
                speed: 30,
                size: "Medium",
                ability_bonuses: [
                    {
                        "skill_name" => "str",
                        "bonus" => 1
                    },
                    {
                        "skill_name" => "dex",
                        "bonus" => 1
                    },
                    {
                        "skill_name" => "con",
                        "bonus" => 1
                    },
                    {
                        "skill_name" => "int",
                        "bonus" => 1
                    },
                    {
                        "skill_name" => "wis",
                        "bonus" => 1
                    },
                    {
                        "skill_name" => "cha",
                        "bonus" => 1
                    }
                ],
                age: "Humans reach adulthood in their late teens and live less than a century.",
                alignment: "Humans tend toward no particular alignment. The best and the worst are found among them.",
                size_description: "Humans vary widely in height and build, from barely 5 feet to well over 6 feet tall. Regardless of your position in that range, your size is Medium.",
                language_desc: "You can speak, read, and write Common and one extra language of your choice. Humans typically learn the languages of other peoples they deal with, including obscure dialects. They are fond of sprinkling their speech with words borrowed from other tongues: Orc curses, Elvish musical expressions, Dwarvish military phrases, and so on.",
                languages: [
                    {
                        "language_name" => "common"
                    }
                ]
            }

            response = Faraday.get("https://www.dnd5eapi.co/api/2014/races/human")
            test_response = JSON.parse(response.body, symbolize_names: true)

            human = RacePoro.new(test_response)
            
            expect(human).to be_an_instance_of RacePoro
            expect(human.id).to eq(expected_poro[:id])
            expect(human.name).to eq(expected_poro[:name])
            #   expect(human.description).to eq(expected_poro[:description])
            expect(human.speed).to eq(expected_poro[:speed])
            expect(human.size).to eq(expected_poro[:size])
            expect(human.ability_bonuses.first[:ability_score][:index]).to eq(expected_poro[:ability_bonuses].first["skill_name"])
            expect(human.age_description).to eq(expected_poro[:age])
            expect(human.alignment_description).to eq(expected_poro[:alignment])
            expect(human.size_description).to eq(expected_poro[:size_description])
            expect(human.language_description).to eq(expected_poro[:language_desc])
            expect(human.languages.first[:index]).to eq(expected_poro[:languages].first["language_name"])
        end
    end
  end
end
