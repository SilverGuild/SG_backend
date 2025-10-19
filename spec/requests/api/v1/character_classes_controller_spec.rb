require "rails_helper"

RSpec.describe "character_classes endpoints", type: :request do
  describe "RESTful endpoints" do
    describe "GET /api/v1/character_classes" do
      it "should retrieve all character classes directly from dnd5e api" do
        VCR.use_cassette("character_classes") do
          get "/api/v1/character_classes"
          expect(response).to be_successful

          json = JSON.parse(response.body, symbolize_names: true)

          character_classes = json[:data]
          expect(character_classes.count).to eq(12)

          first_class = character_classes.first
          last_class = character_classes.last

          expect(first_class[:type]).to eq("character_class")
          expect(first_class[:id]).to eq(@barbarian[:index])
          expect(first_class[:attributes][:name]).to eq(@barbarian[:name])

          expect(last_class[:type]).to eq("character_class")
          expect(last_class[:id]).to eq(@wizard[:index])
          expect(last_class[:attributes][:name]).to eq(@wizard[:name])
        end
      end
    end

    describe "GET /api/v1/character_class/{ID}" do
      it "should retrieve one character class" do
        VCR.use_cassette("character_class_warlock") do
          target_id = "warlock"
          get "/api/v1/character_classes/#{target_id}"

          expect(response).to be_successful

          json = JSON.parse(response.body, symbolize_names: true)
          target = json[:data]

          expect(target[:type]).to eq("character_class")
          expect(target[:id]).to eq(@warlock[:index])
          expect(target[:attributes][:name]).to eq(@warlock[:name])
          expect(target[:attributes][:hit_die]).to eq(@warlock[:hit_die])
          expect(target[:attributes][:skill_proficiencies][:choose]).to eq(@warlock[:skill_proficiencies].first["choose"])
          expect(target[:attributes][:skill_proficiencies][:skills]).to eq(@warlock[:skill_proficiencies].first["skills"])
          expect(target[:attributes][:saving_throw_proficiencies]).to eq(@warlock[:saving_throw_proficiencies])
        end
      end
    end
  end
end
