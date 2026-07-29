require "rails_helper"

RSpec.describe "API::V1::CharacterCombatStats", type: :request do
  let(:password) { "password123" }

  before(:each) do
     @user = User.create!(username: "user1", email: "user1@gmail.com", password: password)

    @character1 = Character.create!(name: "Kaelynn Thornwick",
                                    level: 5,
                                    experience_points: 6500,
                                    alignment: "Neutral Good",
                                    background: "Hermit",
                                    user_id: @user.id,
                                    character_class_id: "druid",
                                    race_id: "gnome",
                                    subclass_id: "land",
                                    subrace_id: "rock-gnome",
                                    languages: [ "common", "gnomish" ])

    @character2 = Character.create!(name: "Theren Nightblade",
                                          level: 5,
                                          experience_points: 500,
                                          alignment: "Lawful Evil",
                                          background: "Aristocrate",
                                          user_id: @user.id,
                                          character_class_id: "paladin",
                                          race_id: "dragonborn",
                                          subclass_id: "devotion",
                                          subrace_id: "",
                                          languages: [ "common", "draconic" ])

    @combat_stats1 = CharacterCombatStats.create!(character: @character1, current_hp: 30, max_hp: 38,
                                                  temporary_hp: 0, hit_dice_remaining: 5,
                                                    death_save_successes: 0, death_save_failures: 0,
                                                    stable: false, armor_class: 15, conditions: [])
  end

  describe "GET /api/v1/character/:character_id/combat_stats" do
    context "happy paths" do
      it "should retrieve the combat stats for a character" do
        get "/api/v1/characters/#{@character1.id}/combat_stats"

        expect(response).to be_successful

        json = JSON.parse(response.body, symbolize_names: true)
        stats = json[:data].first

        expect(stats[:id]).to eq(@combat_stats1[:id])
        expect(stats[:attributes][:character_id]).to eq(@combat_stats1[:character_id])
        expect(stats[:attributes][:current_hp]).to eq(@combat_stats1[:current_hp])
        expect(stats[:attributes][:max_hp]).to eq(@combat_stats1[:max_hp])
        expect(stats[:attributes][:armor_class]).to eq(@combat_stats1[:armor_class])
      end
    end

    context "sad paths" do
      it "returns a 400 status when character ID is invalid format" do
        get "/api/v1/characters/invalid/combat_stats"

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to include("error" => "Invalid character ID")
      end

      xit "returns a 401 status when the user is not authenticated" do
      end

      it "returns a 404 status when the target character is not found" do
        get "/api/v1/characters/999999999999/combat_stats"

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include("error" => "Character not found")
      end

      it "returns a 404 status whent he target character has no combat stats" do
        get "/api/v1/characters/#{@character2.id}/combat_stats"

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include("error" => "Combat Stats not found")
      end
    end
  end

  describe "POST /api/v1/characters/:character_id/combat_stats" do
    context "happy paths" do
      it "should create combat stats for a specific character and return 201 Created status" do
        test_params = { current_hp: 20, max_hp: 20, temporary_hp: 0, hit_dice_remaining: 5, death_save_successes: 0, death_save_failures: 0, stable: false, armor_class: 14, conditions: [] }

        post "/api/v1/characters/#{@character2.id}/combat_stats", params: { character_combat_stat: test_params }, as: :json

        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body, symbolize_names: true)
        test_stats = json[:data].first

        expect(test_stats[:attributes][:character_id]).to eq(@character2.id)
        expect(test_stats[:attributes][:current_hp]).to eq(test_params[:current_hp])
        expect(test_stats[:attributes][:max_hp]).to eq(test_params[:max_hp])
        expect(test_stats[:attributes][:armor_class]).to eq(test_params[:armor_class])

        character = Character.find(@character2.id)
        expect(character.combat_stats).to be_present
        expect(character.combat_stats.id).to eq(test_stats[:id])
      end
    end

    context "sad paths" do
      it "returns 400 status when character ID is invalid format" do
        post "/api/v1/characters/invalid/combat_stats", as: :json

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to include("error" => "Invalid character ID")
      end

      shared_examples "returns 400 for invalid parameter" do |param, invalid_value, error_message|
        it "returns 400 status when #{param} is #{invalid_value.inspect}" do
          text_params = { current_hp: 20, max_hp: 20, temporary_hp: 0, hit_dice_remaining: 5, death_save_successes: 0, death_save_failures: 0, stable: false, armor_class: 14, conditions: [] }.merge(param => invalid_value)

          post "/api/v1/characters/#{@character2.id}/combat_stats", params: { character_combat_stat: text_params }, as: :json

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => error_message)
        end
      end

      context "empty/nil parameters" do
        it_behaves_like "returns 400 for invalid parameter", :current_hp, nil, "Current hp can't be blank"
        it_behaves_like "returns 400 for invalid parameter", :max_hp, nil, "Max hp can't be blank"
        it_behaves_like "returns 400 for invalid parameter", :hit_dice_remaining, nil, "Hit dice remaining can't be blank"
        it_behaves_like "returns 400 for invalid parameter", :armor_class, nil, "Armor class can't be blank"
        it_behaves_like "returns 400 for invalid parameter", :stable, nil, "Stable is not included in the list"
      end

      context "invalid parameters" do
        it_behaves_like "returns 400 for invalid parameter", :current_hp, "abc", "Current hp is not a number"
        it_behaves_like "returns 400 for invalid parameter", :current_hp, -1, "Current hp must be greater than or equal to 0"
        it_behaves_like "returns 400 for invalid parameter", :current_hp, 999, "Current hp can't exceed max hp"
        it_behaves_like "returns 400 for invalid parameter", :hit_dice_remaining, 6, "Hit dice remaining can't exceed character level"
        it_behaves_like "returns 400 for invalid parameter", :death_save_successes, 4, "Death save successes must be less than or equal to 3"
        it_behaves_like "returns 400 for invalid parameter", :conditions, [ "Poisoned!" ], "Conditions contains an invalid condition slug"
      end

      xit "returns a 401 status when user is not authenticated" do
      end

      it "returns a 404 status target character is not found" do
        post "/api/v1/characters/99999999999/combat_stats", as: :json

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include("error" => "Character not found")
      end

      it "returns a 422 status when combat stats already exist for target character" do
        test_params = { current_hp: 20, max_hp: 20, temporary_hp: 0, hit_dice_remaining: 5,
                          death_save_successes: 0, death_save_failures: 0, stable: false,
                          armor_class: 14, conditions: [] }

        post "/api/v1/characters/#{@character1.id}/combat_stats", params: { character_combat_stat: test_params }, as: :json

        expect(response).to have_http_status(:unprocessable_content)
        expect(JSON.parse(response.body)).to include("error" => "Combat Stat already exists for this character")
      end
    end
  end
end
