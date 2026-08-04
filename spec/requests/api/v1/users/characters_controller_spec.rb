require "rails_helper"

RSpec.describe "API::V1::Users::Characters", type: :request do
  describe "RESTful endpoints" do
    let(:password) { "password123" }

    before(:each) do
      @user1 = User.create!(username: "user1", email: "user1@gmail.com", password: password)
      @user2 = User.create!(username: "user2", email: "user2@gmail.com", password: password)

      @character1 = Character.create!(name: "Kaelynn Thornwick",
                                      level: 1,
                                      experience_points: 0,
                                      alignment: "Neutral Good",
                                      background: "Hermit",
                                      user_id: @user1.id,
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
                                      user_id: @user1.id,
                                      character_class_id: "paladin",
                                      race_id: "dragonborn",
                                      subclass_id: "devotion",
                                      subrace_id: "",
                                      languages: [ "common", "draconic" ])
      @character3 = Character.create!(name: "Mira Stormhaven",
                                      level: 8,
                                      experience_points: 853,
                                      alignment: "Chaotic Neutral",
                                      background: "Acolyte",
                                      user_id: @user1.id,
                                      character_class_id: "fighter",
                                      race_id: "halfling",
                                      subclass_id: "champion",
                                      subrace_id: "lightfoot-halfling",
                                      languages: [ "common", "halfling" ])
    end

    describe "GET /api/v1/users/:id/characters" do
      context "happy paths" do
        it "should retrieve all a users characters" do
          get "/api/v1/users/#{@user1.id}/characters"
          expect(response).to be_successful

          json = JSON.parse(response.body, symbolize_names: true)

          characters = json[:data]
          expect(characters.count).to eq(3)

          first_character = characters.first
          last_character = characters.last

          expect(first_character[:id]).to eq(@character1[:id])
          expect(first_character[:attributes][:name]).to eq(@character1[:name])
          expect(first_character[:attributes][:level]).to eq(@character1[:level])
          expect(first_character[:attributes][:experience_points]).to eq(@character1[:experience_points])
          expect(first_character[:attributes][:aligment]).to eq(@character1[:aligment])
          expect(first_character[:attributes][:background]).to eq(@character1[:background])
          expect(first_character[:attributes][:user_id]).to eq(@character1[:user_id])
          expect(first_character[:attributes][:character_class_id]).to eq(@character1[:character_class_id])
          expect(first_character[:attributes][:race_id]).to eq(@character1[:race_id])
          expect(first_character[:attributes][:subclass_id]).to eq(@character1[:subclass_id])
          expect(first_character[:attributes][:subrace_id]).to eq(@character1[:subrace_id])
          expect(first_character[:attributes][:languages]).to eq(@character1[:languages])

          expect(last_character[:id]).to eq(@character3[:id])
          expect(last_character[:attributes][:name]).to eq(@character3[:name])
          expect(last_character[:attributes][:level]).to eq(@character3[:level])
          expect(last_character[:attributes][:experience_points]).to eq(@character3[:experience_points])
          expect(last_character[:attributes][:aligment]).to eq(@character3[:aligment])
          expect(last_character[:attributes][:background]).to eq(@character3[:background])
          expect(last_character[:attributes][:user_id]).to eq(@character3[:user_id])
          expect(last_character[:attributes][:character_class_id]).to eq(@character3[:character_class_id])
          expect(last_character[:attributes][:race_id]).to eq(@character3[:race_id])
          expect(last_character[:attributes][:subclass_id]).to eq(@character3[:subclass_id])
          expect(last_character[:attributes][:subrace_id]).to eq(@character3[:subrace_id])
          expect(last_character[:attributes][:languages]).to eq(@character3[:languages])
        end
      end

      context "sad paths" do
        it "returns a 400 status when user ID is invalid format" do
          get "/api/v1/users/invalid/characters", as: :json

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Invalid user ID")
        end

        xit "returns a 401 status when user is not authenticated" do
        end

        it "returns a 404 status when target user is not found" do
          get "/api/v1/users/9999999999/characters", as: :json

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include("error" => "User not found")
        end

        it "returns a 404 status when target user has no characters" do
          get "/api/v1/users/#{@user2.id}/characters"

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include("error" => "No characters were found for this user")
        end
      end
    end

    describe "POST /api/v1/users/:id/characters" do
      context "happy paths" do
        it "should create a new charater for a specific user and return 201 Created status" do
          test_params = {
            name: "Theren Nightwhisper",
            level: 3,
            experience_points: 345,
            alignment: "Chaotic Good",
            background: "Folk Hero",
            character_class_id: "wizard",
            race_id: "half-elf",
            subclass_id: "evocation",
            subrace_id: "",
            languages: [ "common", "elvish" ]
          }

          post "/api/v1/users/#{@user1.id}/characters", params: { character: test_params }, as: :json

          expect(response).to have_http_status(:created)

          json = JSON.parse(response.body, symbolize_names: true)
          test_character = json[:data].first

          expect(Character.exists?(id: test_character[:id])).to be true

          expect(test_character[:attributes][:name]).to eq(test_params[:name])
          expect(test_character[:attributes][:level]).to eq(test_params[:level])
          expect(test_character[:attributes][:experience_points]).to eq(test_params[:experience_points])
          expect(test_character[:attributes][:aligment]).to eq(test_params[:aligment])
          expect(test_character[:attributes][:background]).to eq(test_params[:background])
          expect(test_character[:attributes][:user_id]).to eq(@user1.id)
          expect(test_character[:attributes][:character_class_id]).to eq(test_params[:character_class_id])
          expect(test_character[:attributes][:race_id]).to eq(test_params[:race_id])
          expect(test_character[:attributes][:subclass_id]).to eq(test_params[:subclass_id])
          expect(test_character[:attributes][:subrace_id]).to eq(test_params[:subrace_id])
          expect(test_character[:attributes][:languages]).to eq(test_params[:languages])

          # Aggregate response shape - empty associations when none are sent
          expect(test_character[:attributes][:ability_scores]).to eq([])
          expect(test_character[:attributes][:skills]).to eq([])
          expect(test_character[:attributes][:combat_stats]).to be_nil

          # Show test_character had been added to the existing list of characters
          user = User.find(@user1.id)
          characters = user.characters
          expect(characters.count).to eq(4)

          last_character = characters.last
          expect(last_character[:id]).to eq(test_character[:id])
        end

        it "creates a character with ability_scores, skills, and combat_stats in one request" do
          test_params = {
            name: "Aggregate Test Character #{SecureRandom.hex(4)}",
            level: 1,
            experience_points: 0,
            alignment: "Neutral Good",
            background: "Hermit",
            character_class_id: "wizard",
            race_id: "human",
            languages: [ "common" ]
          }

          ability_scores_params = [
            { ability_id: "str", score: 10, saving_throw_proficient: false },
            { ability_id: "dex", score: 14, saving_throw_proficient: true },
            { ability_id: "con", score: 12, saving_throw_proficient: false },
            { ability_id: "int", score: 16, saving_throw_proficient: true },
            { ability_id: "wis", score: 11, saving_throw_proficient: false },
            { ability_id: "cha", score: 8, saving_throw_proficient: false }
          ]

          skills_params = [ { skill_id: "arcana", proficient: true, expertise: false } ]

          combat_stats_params = {
            current_hp: 8, max_hp: 8, temporary_hp: 0, hit_dice_remaining: 1,
            death_save_successes: 0, death_save_failures: 0, stable: true,
            armor_class: 12, conditions: []
          }

          post "/api/v1/users/#{@user1.id}/characters",
            params: {
              character: test_params,
              ability_scores: ability_scores_params,
              skills: skills_params,
              combat_stats: combat_stats_params
            },
            as: :json

          expect(response).to have_http_status(:created)

          json = JSON.parse(response.body, symbolize_names: true)
          test_character = json[:data].first

          expect(test_character[:attributes][:ability_scores].count).to eq(6)
          expect(test_character[:attributes][:skills].count).to eq(1)
          expect(test_character[:attributes][:combat_stats][:current_hp]).to eq(8)
        end
      end

      context "sad paths" do
        it "returns a 400 status when user ID is invalid format" do
          post "/api/v1/users/invalid/characters",  as: :json

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Invalid user ID")
        end

        shared_examples "returns 400 for invalid parameter" do |param, invalid_value, error_message|
          it "returns 400 status when #{param} is #{invalid_value.inspect}" do
            test_params = {
              name: "Unique Test Character #{SecureRandom.hex(4)}",
              level: 1,
              experience_points: 0,
              alignment: "Neutral Good",
              background: "Folk Hero",
              user_id: @user1.id,
              character_class_id: "wizard",
              race_id: "human",
              languages: [ "common" ]
            }.merge(param => invalid_value)

            post "/api/v1/users/#{@user1.id}/characters", params: { character: test_params }, as: :json

            expect(response).to have_http_status(:bad_request)
            expect(JSON.parse(response.body)).to include("error" => error_message)
          end
        end

        context "empty/nil parameters" do
          it_behaves_like "returns 400 for invalid parameter", :name, "", "Name can't be blank"
          it_behaves_like "returns 400 for invalid parameter", :name, nil, "Name can't be blank"

          it_behaves_like "returns 400 for invalid parameter", :level, nil, "Level can't be blank"

          it_behaves_like "returns 400 for invalid parameter", :experience_points, nil, "Experience points can't be blank"

          it_behaves_like "returns 400 for invalid parameter", :alignment, "", "Alignment can't be blank"
          it_behaves_like "returns 400 for invalid parameter", :alignment, nil, "Alignment can't be blank"

          it_behaves_like "returns 400 for invalid parameter", :background, "", "Background can't be blank"
          it_behaves_like "returns 400 for invalid parameter", :background, nil, "Background can't be blank"

          it_behaves_like "returns 400 for invalid parameter", :character_class_id, "", "Character class can't be blank"
          it_behaves_like "returns 400 for invalid parameter", :character_class_id, nil, "Character class can't be blank"

          it_behaves_like "returns 400 for invalid parameter", :race_id, "", "Race can't be blank"
          it_behaves_like "returns 400 for invalid parameter", :race_id, nil, "Race can't be blank"

          it_behaves_like "returns 400 for invalid parameter", :languages, [], "Languages can't be blank"
        end

        context "invalid parameters" do
          it_behaves_like "returns 400 for invalid parameter", :name, 123, "Name is invalid"
          it_behaves_like "returns 400 for invalid parameter", :level, "abc", "Level is not a number"
          it_behaves_like "returns 400 for invalid parameter", :experience_points, "def", "Experience points is not a number"
          it_behaves_like "returns 400 for invalid parameter", :alignment, 456, "Alignment is invalid"
          it_behaves_like "returns 400 for invalid parameter", :background, 789, "Background is invalid"
          it_behaves_like "returns 400 for invalid parameter", :character_class_id, 1011, "Character class is invalid"
          it_behaves_like "returns 400 for invalid parameter", :race_id, 1213, "Race is invalid"
          it_behaves_like "returns 400 for invalid parameter", :subclass_id, 1415, "Subclass is invalid"
          it_behaves_like "returns 400 for invalid parameter", :subrace_id, 1617, "Subrace is invalid"
        end

        context "duplicate association ids" do
          it "returns a 400 and does not create a character when ability_scores has a duplicate ability_id" do
            test_params = {
              name: "Unique Test Character #{SecureRandom.hex(4)}",
              level: 1, experience_points: 0, alignment: "Neutral Good", background: "Folk Hero",
              character_class_id: "wizard", race_id: "human", languages: [ "common" ]
            }

            ability_scores_params = [
              { ability_id: "str", score: 10, saving_throw_proficient: false },
              { ability_id: "str", score: 12, saving_throw_proficient: true }
            ]

            post "/api/v1/users/#{@user1.id}/characters",
              params: { character: test_params, ability_scores: ability_scores_params },
              as: :json

            expect(response).to have_http_status(:bad_request)
            expect(Character.exists?(name: test_params[:name])).to be false
          end
          it "returns a 400 and does not create a character when skills has a duplicate skill_id" do
            test_params = {
              name: "Unique Test Character #{SecureRandom.hex(4)}",
              level: 1, experience_points: 0, alignment: "Neutral Good", background: "Folk Hero",
              character_class_id: "wizard", race_id: "human", languages: [ "common" ]
            }

            skills_params = [
              { skill_id: "arcana", proficient: true, expertise: false },
              { skill_id: "arcana", proficient: false, expertise: false }
            ]

            post "/api/v1/users/#{@user1.id}/characters",
              params: { character: test_params, skills: skills_params },
              as: :json

            expect(response).to have_http_status(:bad_request)
            expect(Character.exists?(name: test_params[:name])).to be false
          end
        end

        it "rolls back the whole character when a nested ability score fails validation" do
          test_params = {
            name: "Rollback Test Character #{SecureRandom.hex(4)}",
            level: 1, experience_points: 0, alignment: "Neutral Good", background: "Folk Hero",
            character_class_id: "wizard", race_id: "human", languages: [ "common" ]
          }

          ability_scores_params = [ { ability_id: "str", score: 999, saving_throw_proficient: false } ]

          post "/api/v1/users/#{@user1.id}/characters",
            params: { character: test_params, ability_scores: ability_scores_params },
            as: :json

          expect(response).to have_http_status(:bad_request)
          expect(Character.exists?(name: test_params[:name])).to be false
        end

        xit "returns 401 status when user is not authenticated" do
        end

        it "returns a 4040 status when target user is not found" do
          post "/api/v1/users/99999999/characters", as: :json

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include("error" => "User not found")
        end

        it "returns a 422 status when a character name already exists" do
          test_params = {
            name: "Theren Nightblade",
            level: 1,
            experience_points: 54,
            alignment: "Chaotic Evil",
            background: "Folk",
            character_class_id: "warlock",
            race_id: "half-elf",
            subclass_id: "evocation",
            subrace_id: "",
            languages: [ "common", "elvish" ]
          }

          post "/api/v1/users/#{@user1.id}/characters", params: { character: test_params }, as: :json

          expect(response).to have_http_status(:unprocessable_content)
          expect(JSON.parse(response.body)).to include("error" => "Character already exists with this name")
        end
      end
    end
  end
end
