require "rails_helper"

RSpec.describe "races endpoints", type: :request do
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
