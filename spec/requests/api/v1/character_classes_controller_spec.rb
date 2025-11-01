require "rails_helper"

RSpec.describe "API::V1::CharacterClasses", type: :request do
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
          expect(first_class[:id]).to eq("barbarian")
          expect(first_class[:attributes][:name]).to eq("Barbarian")

          expect(last_class[:type]).to eq("character_class")
          expect(last_class[:id]).to eq("wizard")
          expect(last_class[:attributes][:name]).to eq("Wizard")
        end
      end
    end

    describe "GET /api/v1/character_classes/:id" do
      describe "happy paths" do
        it "should retrieve one character class" do
          VCR.use_cassette("character_class_warlock") do
            target_id = "warlock"
            get "/api/v1/character_classes/#{target_id}"

            expect(response).to be_successful

            json = JSON.parse(response.body, symbolize_names: true)
            target = json[:data]

            expect(target[:type]).to eq("character_class")
            expect(target[:id]).to eq("warlock")
            expect(target[:attributes][:name]).to eq("Warlock")
            expect(target[:attributes][:hit_die]).to eq(8)
            expect(target[:attributes][:skill_proficiencies][:choose]).to eq(2)
            expect(target[:attributes][:skill_proficiencies][:skills]).to eq([ "arcana", "deception", "history", "intimidation", "investigation", "nature", "religion" ])
            expect(target[:attributes][:saving_throw_proficiencies]).to eq([ "wis", "cha" ])
          end
        end
      end

      describe "sad paths" do
        before do
          stub_request(:get, "https://www.dnd5eapi.co/api/2014/classes/test").to_return(status: 404, body: { error: "Not found" }.to_json)
        end

        it "returns a 404 status when target character class does not exist" do
          get "/api/v1/character_classes/test"

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include("error" => "Character class not found")
        end
      end
    end
  end
end
