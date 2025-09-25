require "rails_helper"

RSpec.describe "races endpoints", type: :request do
    describe "RESTful endpoints" do
        before(:each) do
            @race1 = Race.create!(name: "Tiefling",
                                    description: "My favroite character race to play",
                                    speed: 30,
                                    size: "medium",
                                    ability_bonuses: [
                                        {
                                            "skill_name" => "int",
                                            "bonus" => 1
                                        },
                                        {
                                            "skill_name" => "cha",
                                            "bonus" => 2
                                        }
                                    ],
                                    age_description: "Tieflings mature at the same rate as humans but live a few years longer.",
                                    alignment_description: "Tieflings might not have an innate tendency toward evil, but many of them end up there. Evil or not, an independent nature inclines many tieflings toward a chaotic alignment.",
                                    size_description: "Tieflings are about the same size and build as humans. Your size is Medium.",
                                    languages_description: "You can speak, read, and write Common and Infernal.",
                                    languages: [
                                        {
                                            "language_name" => "common"
                                        },
                                        {
                                            "language_name" => "infernal"
                                        }
                                    ]
                                )
            @race2 = Race.create!(name: "Dwarf",
                                    description: "Small but mighty",
                                    speed: 25,
                                    size: "medium",
                                    ability_bonuses: [
                                        {
                                            "skill_name" => "con",
                                            "bonus" => 2
                                        }
                                    ],
                                    age_description: "Dwarves mature at the same rate as humans, but they're considered young until they reach the age of 50. On average, they live about 350 years.",
                                    alignment_description: "Most dwarves are lawful, believing firmly in the benefits of a well-ordered society. They tend toward good as well, with a strong sense of fair play and a belief that everyone deserves to share in the benefits of a just order.",
                                    size_description: "Dwarves stand between 4 and 5 feet tall and average about 150 pounds. Your size is Medium.",
                                    languages_description: "You can speak, read, and write Common and Dwarvish. Dwarvish is full of hard consonants and guttural sounds, and those characteristics spill over into whatever other language a dwarf might speak.",
                                    languages: [
                                        {
                                            "language_name" => "common"
                                        }, {
                                            "language_name" => "dwarvish"
                                        }
                                    ]
                                )

            @race3 = Race.create!(name: "Human",
                                    description: "He's simple but reliable",
                                    speed: 30,
                                    size: "medium",
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
                                    age_description: "Humans reach adulthood in their late teens and live less than a century.",
                                    alignment_description: "Humans tend toward no particular alignment. The best and the worst are found among them.",
                                    size_description: "Humans vary widely in height and build, from barely 5 feet to well over 6 feet tall. Regardless of your position in that range, your size is Medium.",
                                    languages_description: "You can speak, read, and write Common and one extra language of your choice. Humans typically learn the languages of other peoples they deal with, including obscure dialects. They are fond of sprinkling their speech with words borrowed from other tongues: Orc curses, Elvish musical expressions, Dwarvish military phrases, and so on.",
                                    languages: [
                                        {
                                            "language_name" => "common"
                                        }
                                    ]
                                )

            @target_id = @race2.id
        end

        describe "GET /api/v1/races" do
            it "should retrieve all character races" do
                get "/api/v1/races"
                expect(response).to be_successful

                json = JSON.parse(response.body, symbolize_names: true)

                races = json[:data]
                expect(races.count).to eq(3)

                first_race = races.first
                last_race = races.last

                expect(first_race[:id]).to eq(@race1.id)
                expect(first_race[:attributes][:name]).to eq(@race1.name)
                expect(first_race[:attributes][:description]).to eq(@race1.description)
                expect(first_race[:attributes][:speed]).to eq(@race1.speed)
                expect(first_race[:attributes][:size]).to eq(@race1.size)
                expect(first_race[:attributes][:ability_bonuses].first[:skill_name]).to eq(@race1.ability_bonuses.first["skill_name"])
                expect(first_race[:attributes][:age_description]).to eq(@race1.age_description)
                expect(first_race[:attributes][:alignment_description]).to eq(@race1.alignment_description)
                expect(first_race[:attributes][:size_description]).to eq(@race1.size_description)
                expect(first_race[:attributes][:languages_description]).to eq(@race1.languages_description)
                expect(first_race[:attributes][:languages].first[:language_name]).to eq(@race1.languages.first["language_name"])

                expect(last_race[:id]).to eq(@race3.id)
                expect(last_race[:attributes][:name]).to eq(@race3.name)
                expect(last_race[:attributes][:description]).to eq(@race3.description)
                expect(last_race[:attributes][:speed]).to eq(@race3.speed)
                expect(last_race[:attributes][:size]).to eq(@race3.size)
                expect(last_race[:attributes][:ability_bonuses].first[:skill_name]).to eq(@race3.ability_bonuses.first["skill_name"])
                expect(last_race[:attributes][:age_description]).to eq(@race3.age_description)
                expect(last_race[:attributes][:alignment_description]).to eq(@race3.alignment_description)
                expect(last_race[:attributes][:size_description]).to eq(@race3.size_description)
                expect(last_race[:attributes][:languages_description]).to eq(@race3.languages_description)
                expect(last_race[:attributes][:languages].first[:language_name]).to eq(@race3.languages.first["language_name"])
            end
        end

        describe "GET /api/v1/races/{ID}" do
            it "should retrieve one character race" do
                get "/api/v1/races/#{@target_id}"
                expect(response).to be_successful

                json = JSON.parse(response.body, symbolize_names: true)

                target = json[:data].first

                expect(target[:id]).to eq(@race2.id)
                expect(target[:attributes][:name]).to eq(@race2.name)
                expect(target[:attributes][:description]).to eq(@race2.description)
                expect(target[:attributes][:speed]).to eq(@race2.speed)
                expect(target[:attributes][:size]).to eq(@race2.size)
                expect(target[:attributes][:ability_bonuses].first[:skill_name]).to eq(@race2.ability_bonuses.first["skill_name"])
                expect(target[:attributes][:age_description]).to eq(@race2.age_description)
                expect(target[:attributes][:alignment_description]).to eq(@race2.alignment_description)
                expect(target[:attributes][:size_description]).to eq(@race2.size_description)
                expect(target[:attributes][:languages_description]).to eq(@race2.languages_description)
                expect(target[:attributes][:languages].first[:language_name]).to eq(@race2.languages.first["language_name"])
            end
        end
    end
end
