require "rails_helper"

RSpec.describe "races endpoints", type: :request do
    describe "RESTful endpoints" do
        before(:each) do
            @dragonborn = { 
                name: "Dragonborn",
                description: "Big lizard!",
                speed: 30,
                size: "medium",
                ability_bonuses: [
                    {
                        "skill_name" => "str",
                        "bonus" => 2
                    },
                    {
                        "skill_name" => "cha",
                        "bonus" => 1
                    }
                ],
                age_description: "Young dragonborn grow quickly. They walk hours after hatching, attain the size and development of a 10-year-old human child by the age of 3, and reach adulthood by 15. They live to be around 80.",
                alignment_description: "Dragonborn tend to extremes, making a conscious choice for one side or the other in the cosmic war between good and evil. Most dragonborn are good, but those who side with evil can be terrible villains.",
                size_description: "Dragonborn are taller and heavier than humans, standing well over 6 feet tall and averaging almost 250 pounds. Your size is Medium.",
                languages_description: "You can speak, read, and write Common and Draconic. Draconic is thought to be one of the oldest languages and is often used in the study of magic. The language sounds harsh to most other creatures and includes numerous hard consonants and sibilants.",
                languages: [
                    {
                        "language_name" => "common"
                    }, {
                        "language_name" => "draconic"
                    }
                ]
            }
            
            @tiefling = {   
                name: "Tiefling",
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
            }

            @half_orc = { 
                name: "Half-orc",
                description: "No one looks better with an axe!",
                speed: 30,
                size: "medium",
                ability_bonuses: [
                    {
                        "skill_name" => "str",
                        "bonus" => 2
                    },
                    {
                        "skill_name" => "con",
                        "bonus" => 1
                    }
                ],
                age_description: "Half-orcs mature a little faster than humans, reaching adulthood around age 14. They age noticeably faster and rarely live longer than 75 years.",
                alignment_description: "Half-orcs inherit a tendency toward chaos from their orc parents and are not strongly inclined toward good. Half-orcs raised among orcs and willing to live out their lives among them are usually evil.",
                size_description: "Half-orcs are somewhat larger and bulkier than humans, and they range from 5 to well over 6 feet tall. Your size is Medium.",
                languages_description: "You can speak, read, and write Common and Orc. Orc is a harsh, grating language with hard consonants. It has no script of its own but is written in the Dwarvish script.",
                languages: [
                    {
                        "language_name" => "common"
                    }, {
                        "language_name" => "orc"
                    }
                ]
            }
        end

        describe "GET /api/v1/races" do
            it "should retrieve all character races directly from dnd5eapi" do
                VCR.use_cassette("character_classes") do
                    get "/api/v1/races"
                    expect(response).to be_successful

                    json = JSON.parse(response.body, symbolize_names: true)

                    races = json[:data]
                    expect(races.count).to eq(3)

                    first_race = races.first
                    last_race = races.last

                    expect(first_race).to be_an_instance_of RacePoro
                    expect(first_race.name).to eq(@dragonborn[:name])
                    expect(first_race.description).to eq(@dragonborn[:description])
                    expect(first_race.speed).to eq(@dragonborn[:speed])
                    expect(first_race.size).to eq(@dragonborn[:size])
                    expect(first_race.ability_bonuses.first[:skill_name]).to eq(@dragonborn[:ability_bonuses].first["skill_name"])
                    expect(first_race.age_description).to eq(@dragonborn[:age_description])
                    expect(first_race.alignment_description).to eq(@dragonborn[:alignment_description])
                    expect(first_race.size_description).to eq(@dragonborn[:size_description])
                    expect(first_race.languages_description).to eq(@dragonborn[:languages_description])
                    expect(first_race.languages.first[:language_name]).to eq(@dragonborn[:languages].first["language_name"])

                    expect(last_race).to be_an_instance_of RacePoro
                    expect(last_race.name).to eq(@tiefling[:name])
                    expect(last_race.description).to eq(@tiefling[:description])
                    expect(last_race.speed).to eq(@tiefling[:speed])
                    expect(last_race.size).to eq(@tiefling[:size])
                    expect(last_race.ability_bonuses.first[:skill_name]).to eq(@tiefling[:ability_bonuses].first["skill_name"])
                    expect(last_race.age_description).to eq(@tiefling[:age_description])
                    expect(last_race.alignment_description).to eq(@tiefling[:alignment_description])
                    expect(last_race.size_description).to eq(@tiefling[:size_description])
                    expect(last_race.languages_description).to eq(@tiefling[:languages_description])
                    expect(last_race.languages.first[:language_name]).to eq(@tiefling[:languages].first["language_name"])
                end
            end
        end

        describe "GET /api/v1/races/{ID}" do
            it "should retrieve one character race" do
                VCR.use_cassette("single_character_race_half_orc") do
                    target_id = "half-orc"
                    get "/api/v1/races/#{target_id}"

                    expect(response).to be_successful

                    json = JSON.parse(response.body, symbolize_names: true)

                    target = json[:data].first
                
                    expect(target).to be_an_instance_of RacePoro
                    expect(target.name).to eq(@half_orc[:name])
                    expect(target.description).to eq(@half_orc[:description])
                    expect(target.speed).to eq(@half_orc[:speed])
                    expect(target.size).to eq(@half_orc[:size])
                    expect(target.ability_bonuses.first[:skill_name]).to eq(@half_orc[:ability_bonuses].first["skill_name"])
                    expect(target.age_description).to eq(@half_orc[:age_description])
                    expect(target.alignment_description).to eq(@half_orc[:alignment_description])
                    expect(target.size_description).to eq(@half_orc[:size_description])
                    expect(target.languages_description).to eq(@half_orc[:languages_description])
                    expect(target.languages.first[:language_name]).to eq(@half_orc[:languages].first["language_name"])
                end
        end
    end
end
