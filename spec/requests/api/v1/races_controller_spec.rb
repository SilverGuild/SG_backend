require "rails_helper"

RSpec.describe "API::V1::Races", type: :request do
    describe "RESTful endpoints" do
        describe "GET /api/v1/races" do
            it "should retrieve all character races directly from dnd5e api" do
                VCR.use_cassette("character_races") do
                    get "/api/v1/races"
                    expect(response).to be_successful

                    json = JSON.parse(response.body, symbolize_names: true)

                    races = json[:data]
                    expect(races.count).to eq(9)

                    first_race = races.first
                    last_race = races.last

                    expect(first_race[:type]).to eq("race")
                    expect(first_race[:id]).to eq("dragonborn")
                    expect(first_race[:attributes][:name]).to eq("Dragonborn")

                    expect(last_race[:type]).to eq("race")
                    expect(last_race[:id]).to eq("tiefling")
                    expect(last_race[:attributes][:name]).to eq("Tiefling")
                end
            end
        end

        describe "GET /api/v1/races/:id" do
            it "should retrieve one character race and detailed information" do
                VCR.use_cassette("single_character_race_half_orc") do
                    target_id = "half-orc"
                    get "/api/v1/races/#{target_id}"

                    expect(response).to be_successful

                    json = JSON.parse(response.body, symbolize_names: true)

                    target = json[:data]

                    expect(target[:type]).to eq("race")
                    expect(target[:id]).to eq("half-orc")
                    expect(target[:attributes][:name]).to eq("Half-Orc")
                    expect(target[:attributes][:speed]).to eq(30)
                    expect(target[:attributes][:size]).to eq("Medium")
                    expect(target[:attributes][:ability_bonuses].first[:ability_score][:name]).to eq("STR")
                    expect(target[:attributes][:ability_bonuses].first[:bonus]).to eq(2)
                    expect(target[:attributes][:age_description]).to eq("Half-orcs mature a little faster than humans, reaching adulthood around age 14. They age noticeably faster and rarely live longer than 75 years.")
                    expect(target[:attributes][:alignment_description]).to eq("Half-orcs inherit a tendency toward chaos from their orc parents and are not strongly inclined toward good. Half-orcs raised among orcs and willing to live out their lives among them are usually evil.")
                    expect(target[:attributes][:size_description]).to eq("Half-orcs are somewhat larger and bulkier than humans, and they range from 5 to well over 6 feet tall. Your size is Medium.")
                    expect(target[:attributes][:language_description]).to eq("You can speak, read, and write Common and Orc. Orc is a harsh, grating language with hard consonants. It has no script of its own but is written in the Dwarvish script.")
                    expect(target[:attributes][:languages].first[:name]).to eq("Common")
                end
            end
        end
    end
end
