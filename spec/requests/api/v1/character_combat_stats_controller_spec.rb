require "rails_helper"

RSpec.describe "API::V1::CharacterCombatStats", type: :request do
  describe "RESTful enpoints" do
    let(:password) {"password123"}

    before(:each) do
      @user = User.create!(username: "user1", email: "user1@gmail.com", password: password)

      @character = Character.create!(name: "Kaelynn Thornwick",
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

      @combat_stats = CharacterCombatStats.create!(character: @character, current_hp: 30, max_hp: 38,
                                                  temporary_hp: 0, hit_dice_remaining: 5,
                                                  death_save_successes: 0, death_save_failures: 0,
                                                  stable: false, armor_class: 15, conditions: [])

      @target_id = @combat_stats.id
    end

    describe "PATCH /api/v1/character_combat_stats/:id" do
      let(:valid_params) { { current_hp: 25, temporary_hp: 5, stable: true } }

      context "happy paths" do
        it "should update a combat stats entry in the db and return successful status" do
          stats = CharacterCombatStats.find(@target_id)

          patch "/api/v1/character_combat_stats/#{@target_id}", params: {character_combat_stat: valid_params }, as: :json
         
          expect(response).to be_successful

          json = JSON.parse(response.body, symbolize_names: true)
          target = json[:data].first

          expect(target[:id]).to eq(stats[:id])
          expect(target[:attributes][:character_id]).to eq(stats[:character_id])
          expect(target[:attributes][:current_hp]).to eq(valid_params[:current_hp])
          expect(target[:attributes][:temporary_hp]).to eq(valid_params[:temporary_hp])
          expect(target[:attributes][:stable]).to eq(valid_params[:stable])

          stats.reload
          
          expect(stats[:current_hp]).to eq(valid_params[:current_hp])
          expect(stats[:temporary_hp]).to eq(valid_params[:temporary_hp])
          expect(stats[:stable]).to eq(valid_params[:stable])
        end
      end

      context "sad paths" do
        it "returns a 400 status when combat stats ID is invalid format" do
          patch "/api/v1/character_combat_stats/invalid", params: { character_combat_stat: valid_params }, as: :json

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Invalid Combat Stat ID")
        end

        shared_examples "returns 400 for invalid parameter" do |param, invalid_value, error_message|
          it "returns 400 when #{param} is #{invalid_value.inspect}" do
            updated_params = { param => invalid_value }

            patch "/api/v1/character_combat_stats/#{@target_id}", params: { character_combat_stat: updated_params }, as: :json

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
          it_behaves_like "returns 400 for invalid parameter", :max_hp, -1, "Max hp must be greater than or equal to 0"
          it_behaves_like "returns 400 for invalid parameter", :temporary_hp, -1, "Temporary hp must be greater than or equal to 0"
          it_behaves_like "returns 400 for invalid parameter", :hit_dice_remaining, -1, "Hit dice remaining must be greater than or equal to 0"
          it_behaves_like "returns 400 for invalid parameter", :hit_dice_remaining, 6, "Hit dice remaining can't exceed character level"
          it_behaves_like "returns 400 for invalid parameter", :death_save_successes, -1, "Death save successes must be greater than or equal to 0"
          it_behaves_like "returns 400 for invalid parameter", :death_save_successes, 4, "Death save successes must be less than or equal to 3"
          it_behaves_like "returns 400 for invalid parameter", :death_save_failures, -1, "Death save failures must be greater than or equal to 0"
          it_behaves_like "returns 400 for invalid parameter", :death_save_failures, 4, "Death save failures must be less than or equal to 3"
          it_behaves_like "returns 400 for invalid parameter", :armor_class, -1, "Armor class must be greater than or equal to 0"
          it_behaves_like "returns 400 for invalid parameter", :conditions, "poisoned", "Conditions is invalid"
          it_behaves_like "returns 400 for invalid parameter", :conditions, [ "Poisoned!" ], "Conditions contains an invalid condition slug"
        end

        xit "returns a 401 when user is not authenticated" do
        end

        xit "returns a 401 when user (non-owner) does not have a dungeon master access" do
        end

        it "returns a 4040 status when target combat stats is not found" do
          patch "/api/v1/character_combat_stats/9999999999", params: { character_combat_stat: { current_hp: 10 } }, as: :json

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include("error" => "Combat Stat not found")
        end

        it "returns a 400 status when attempting to change a character_id" do
           other_character = Character.create!(name: "Theren Nightblade",
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
 
          patch "/api/v1/character_combat_stats/#{@target_id}", params: { character_combat_stat: { character_id: other_character.id } }, as: :json

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Character can't be changed after creation")
        end
      end
    end

    describe "DELETE /api/v1/character_combat_stats/:id" do
      context "happy paths" do
        it "should destroy a combat stat entry by id and return an empty response body" do
          expect {
            delete "/api/v1/character_combat_stats/#{@target_id}"
        }.to change(CharacterCombatStats, :count).by(-1)

        expect(response).to be_successful
        expect(response.body).to be_empty
        expect(CharacterCombatStats.exists?(@target_id)).to be false
        end
      end

      context "sad paths" do
        it "returns a 400 status when combat stats ID is invalid format" do
          delete "/api/v1/character_combat_stats/invalid"

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Invalid Combat Stat ID")
        end

        xit "returns a 401 status when user is not authenticated" do
        end

        xit "returns a 401 status when ser (non-owner) does not have a dungeon master access" do
        end

        it "returns 401 status when target combat stats is not found" do
          delete "/api/v1/character_combat_stats/999999999999"

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include("error" => "Combat Stat not found")
        end
      end
    end
  end
end
