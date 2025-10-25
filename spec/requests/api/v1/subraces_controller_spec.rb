require "rails_helper"

RSpec.describe "API::V1::Subraces", type: :request do
    describe "RESTful endpoints" do
        describe "GET /api/v1/subraces" do
            it "should retrieve all character subraces directly from dnd5e api" do
                VCR.use_cassette("subraces") do
                    get "/api/v1/subraces"
                    expect(response).to be_successful

                    json = JSON.parse(response.body, symbolize_names: true)

                    subraces = json[:data]
                    expect(subraces.count).to eq(4)

                    first_subrace = subraces.first
                    last_subrace = subraces.last

                    expect(first_subrace[:type]).to eq("subrace")
                    expect(first_subrace[:id]).to eq("half-elf")
                    expect(first_subrace[:attributes][:name]).to eq("Half Elf")
                    expect(first_subrace[:attributes][:url]).to eq("/api/2014/subraces/high-elf")

                    expect(last_subrace[:type]).to eq("subrace")
                    expect(last_subrace[:id]).to eq("rock-gnome")
                    expect(last_subrace[:attributes][:name]).to eq("Rock Gnome")
                    expect(first_subrace[:attributes][:url]).to eq("/api/2014/subraces/rock-gnome")
                end
            end
        end

        describe "GET /api/v1/subraces/:id" do
            it "should retrieve one character subrace and detailed information" do
                VCR.use_cassette("single_subrace_hill_dwarf") do
                    target_id = "hill-dwarf"
                    get "/api/v1/subraces/#{target_id}"

                    expect(response).to be_successful

                    json = JSON.parse(response.body, symbolize_names: true)

                    target = json[:data]
                    expect(target[:type]).to eq("subrace")
                    expect(target[:id]).to eq("hill-dwarf")
                    expect(target[:attributes][:name]).to eq("Hill Dwarf")
                    expect(target[:attributes][:race_id]).to eq(30)
                    expect(target[:attributes][:description]).to eq("As a hill dwarf, you have keen senses, deep intuition, and remarkable resilience.")
                    expect(target[:attributes][:ability_bonuses].first[:ability_score][:name]).to eq("WIS")
                    expect(target[:attributes][:ability_bonuses].first[:bonus]).to eq(1)
                    expect(target[:attributes][:url]).to eq("/api/2014/subraces/hill-dwarf")
                end
            end
        end
    end
end
