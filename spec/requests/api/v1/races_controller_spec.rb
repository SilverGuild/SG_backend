require "rails_helper"

RSpec.describe "races endpoints", type: :request do
    describe "RESTful endpoints" do
        before(:each) do
            @dragonborn = { 
                index: "dragonborn",
                name: "Dragonborn",
                speed: 30,
                size: "Medium",
                ability_bonuses: [
                    {
                        "skill_name" => "STR",
                        "bonus" => 2
                    },
                    {
                        "skill_name" => "CHA",
                        "bonus" => 1
                    }
                ],
                age_description: "Young dragonborn grow quickly. They walk hours after hatching, attain the size and development of a 10-year-old human child by the age of 3, and reach adulthood by 15. They live to be around 80.",
                alignment_description: "Dragonborn tend to extremes, making a conscious choice for one side or the other in the cosmic war between good and evil. Most dragonborn are good, but those who side with evil can be terrible villains.",
                size_description: "Dragonborn are taller and heavier than humans, standing well over 6 feet tall and averaging almost 250 pounds. Your size is Medium.",
                language_description: "You can speak, read, and write Common and Draconic. Draconic is thought to be one of the oldest languages and is often used in the study of magic. The language sounds harsh to most other creatures and includes numerous hard consonants and sibilants.",
                languages: [
                    {
                        "language_name" => "Common"
                    }, {
                        "language_name" => "Draconic"
                    }
                ]
            }

            @tiefling = {   
                index: "tiefling",
                name: "Tiefling",
                speed: 30,
                size: "Medium",
                ability_bonuses: [
                    {
                        "skill_name" => "INT",
                        "bonus" => 1
                    },
                    {
                        "skill_name" => "CHA",
                        "bonus" => 2
                    }
                ],
                age_description: "Tieflings mature at the same rate as humans but live a few years longer.",
                alignment_description: "Tieflings might not have an innate tendency toward evil, but many of them end up there. Evil or not, an independent nature inclines many tieflings toward a chaotic alignment.",
                size_description: "Tieflings are about the same size and build as humans. Your size is Medium.",
                language_description: "You can speak, read, and write Common and Infernal.",
                languages: [
                    {
                        "language_name" => "Common"
                    },
                    {
                        "language_name" => "Infernal"
                    }
                ]
            }

            @half_orc = { 
                index: "half-orc",
                name: "Half-Orc",
                speed: 30,
                size: "Medium",
                ability_bonuses: [
                    {
                        "skill_name" => "STR",
                        "bonus" => 2
                    },
                    {
                        "skill_name" => "CON",
                        "bonus" => 1
                    }
                ],
                age_description: "Half-orcs mature a little faster than humans, reaching adulthood around age 14. They age noticeably faster and rarely live longer than 75 years.",
                alignment_description: "Half-orcs inherit a tendency toward chaos from their orc parents and are not strongly inclined toward good. Half-orcs raised among orcs and willing to live out their lives among them are usually evil.",
                size_description: "Half-orcs are somewhat larger and bulkier than humans, and they range from 5 to well over 6 feet tall. Your size is Medium.",
                language_description: "You can speak, read, and write Common and Orc. Orc is a harsh, grating language with hard consonants. It has no script of its own but is written in the Dwarvish script.",
                languages: [
                    {
                        "language_name" => "Common"
                    }, {
                        "language_name" => "Orc"
                    }
                ]
            }
        end

        describe "GET /api/v1/races" do
            it "should retrieve all character races directly from dnd5eapi" do
                VCR.use_cassette("character_racees") do
                    get "/api/v1/races"
                    expect(response).to be_successful

                    json = JSON.parse(response.body, symbolize_names: true)

                    races = json[:data]
                    expect(races.count).to eq(9)

                    first_race = races.first
                    last_race = races.last

                    expect(first_race[:type]).to eq("race")
                    expect(first_race[:id]).to eq(@dragonborn[:index])
                    expect(first_race[:attributes][:name]).to eq(@dragonborn[:name])
                   
                    expect(last_race[:type]).to eq("race")
                    expect(last_race[:id]).to eq(@tiefling[:index])
                    expect(last_race[:attributes][:name]).to eq(@tiefling[:name])
                end
            end
        end

        describe "GET /api/v1/races/{ID}" do
            it "should retrieve one character race and detailed information" do
                VCR.use_cassette("single_character_race_half_orc") do
                    target_id = "half-orc"
                    get "/api/v1/races/#{target_id}"

                    expect(response).to be_successful

                    json = JSON.parse(response.body, symbolize_names: true)

                    target = json[:data]
                    # require "pry"; binding.pry
                    expect(target[:type]).to eq("race")
                    expect(target[:id]).to eq(@half_orc[:index])
                    expect(target[:attributes][:name]).to eq(@half_orc[:name])
                    expect(target[:attributes][:speed]).to eq(@half_orc[:speed])
                    expect(target[:attributes][:size]).to eq(@half_orc[:size])
                    expect(target[:attributes][:ability_bonuses].first[:ability_score][:name]).to eq(@half_orc[:ability_bonuses].first["skill_name"])
                    expect(target[:attributes][:age_description]).to eq(@half_orc[:age_description])
                    expect(target[:attributes][:alignment_description]).to eq(@half_orc[:alignment_description])
                    expect(target[:attributes][:size_description]).to eq(@half_orc[:size_description])
                    expect(target[:attributes][:language_description]).to eq(@half_orc[:language_description])
                    expect(target[:attributes][:languages].first[:name]).to eq(@half_orc[:languages].first["language_name"])
                end
            end
        end
    end
end
