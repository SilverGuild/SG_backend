require "rails_helper"

RSpec.describe "API::V1::Characters::AbilityScores", type: :request do
  describe "RESTful endpoints" do
    let(:password) { "password123" }

    before(:each) do
      @user = User.create!(username: "user1", email: "user1@gmail.com", password: password)

      @character1 = Character.create!(name: "Kaelynn Thornwick",
                                      level: 1,
                                      experience_points: 0,
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

      @score1 = CharacterAbilityScore.create!(character: @character1, ability_id: "str", score: 14, saving_throw_proficient: true)
      @score2 = CharacterAbilityScore.create!(character: @character1, ability_id: "dex", score: 12, saving_throw_proficient: false)
    end

    describe "GET /api/v1/character/:character_id/ability_scores" do
      context "happy paths" do
        it "should retrieve all ability scores for a character" do
          get "/api/v1/characters/#{@character1.id}/ability_scores"

          expect(response).to be_successful

          json = JSON.parse(response.body, symbolize_names: true)
          ability_scores = json[:data]

          expect(ability_scores.count).to eq(2)

          first_ability_score = ability_scores.first
          expect(first_ability_score[:id]).to eq(@score1[:id])
          expect(first_ability_score[:attributes][:character_id]).to eq(@score1[:character_id])
          expect(first_ability_score[:attributes][:ability_id]).to eq(@score1[:ability_id])
          expect(first_ability_score[:attributes][:score]).to eq(@score1[:score])
          expect(first_ability_score[:attributes][:saving_throw_proficient]).to eq(@score1[:saving_throw_proficient])
        end

        it "only returns ability scores belonging to the requested character" do
          CharacterAbilityScore.create!(character: @character2, ability_id: "con", score: "10")

          get "/api/v1/characters/#{@character1.id}/ability_scores"

          json = JSON.parse(response.body, symbolize_names: true)

          expect(json[:data].count).to eq(2)
          expect(json[:data].map { |s| s[:attributes][:ability_id] }).not_to include("con")
        end
      end

      context "sad paths" do
        it "returns a 400 status when character ID is invalid format" do
          get "/api/v1/characters/invalid/ability_scores"

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Invalid character ID")
        end

        xit "returns a 401 status when the user is not authenticated" do
        end

        it "returns a 404 staus when target character is not found" do
          get "/api/v1/characters/99999999999/ability_scores"

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include("error" => "Character not found")
        end

        it "returns a 404 status when the target character has no abilty scores" do
          bare_character = Character.create!(name: "Bare Bones",
                                              level: 1,
                                              experience_points: 0,
                                              alignment: "True Neutral",
                                              background: "Folk Hero",
                                              user_id: @user.id,
                                              character_class_id: "fighter",
                                              race_id: "human",
                                              subclass_id: "",
                                              subrace_id: "",
                                              languages: [ "common" ]
                                            )

          get "/api/v1/characters/#{bare_character.id}/ability_scores"

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include("error" => "No ability scores were found for this character")
        end
      end
    end

    describe "POST /api/v1/characters/:character_id/ability_scores" do
      context "happy paths" do
        it "should create a new abilty score for a specific character and return 201 Created Status" do
          test_params = { ability_id: "con", score: 15, saving_throw_proficient: false }

          post "/api/v1/characters/#{@character1.id}/ability_scores", params: { character_ability_score: test_params }, as: :json

          expect(response).to have_http_status(:created)

          json = JSON.parse(response.body, symbolize_names: true)
          test_score = json[:data].first

          expect(test_score[:attributes][:character_id]).to eq(@character1.id)
          expect(test_score[:attributes][:ability_id]).to eq(test_params[:ability_id])
          expect(test_score[:attributes][:score]).to eq(test_params[:score])
          expect(test_score[:attributes][:saving_throw_proficient]).to eq(test_params[:saving_throw_proficient])

          character = Character.find(@character1.id)
          scores = character.ability_scores
          expect(scores.count).to eq(3)

          last_score = scores.last
          expect(last_score[:id]).to eq(test_score[:id])
        end

        it "allows the same ability_id to exist on a different character" do
          post "/api/v1/characters/#{@character2.id}/ability_scores", params: { character_ability_score: { ability_id: "str", score: 13 } }, as: :json

          expect(response).to have_http_status(:created)
        end
      end

      context "sad paths" do
        it "returns 400 status when character ID is invalid format" do
          post "/api/v1/characters/invalid/ability_scores", as: :json

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Invalid character ID")
        end

        shared_examples "returns 400 for invalid parameter" do |param, invalid_value, error_message|
          it "returns 400 status when #{param} is #{invalid_value.inspect}" do
            test_params = { ability_id: "con", score: 15, saving_throw_proficient: false }.merge(param => invalid_value)

            post "/api/v1/characters/#{@character1.id}/ability_scores", params: { character_ability_score: test_params }, as: :json

            expect(response).to have_http_status(:bad_request)
            expect(JSON.parse(response.body)).to include("error" => error_message)
          end
        end

        context "empty/nil parameters" do
          it_behaves_like "returns 400 for invalid parameter", :ability_id, "", "Ability can't be blank"
          it_behaves_like "returns 400 for invalid parameter", :ability_id, nil, "Ability can't be blank"
          it_behaves_like "returns 400 for invalid parameter", :score, nil, "Score can't be blank"
        end

        context "invalid parameters" do
          it_behaves_like "returns 400 for invalid parameter", :ability_id, "Strength", "Ability is invalid"
          it_behaves_like "returns 400 for invalid parameter", :ability_id, "strength_score", "Ability is invalid"
          it_behaves_like "returns 400 for invalid parameter", :score, "abc", "Score is not a number"
          it_behaves_like "returns 400 for invalid parameter", :score, 0, "Score must be greater than or equal to 1"
          it_behaves_like "returns 400 for invalid parameter", :score, 31, "Score must be less than or equal to 30"
        end

        xit "returns a 401 status when user is not authenticated" do
        end

        it "'returns a 404 status when target character is not found" do
          post "/api/v1/characters/999999999999/ability_scores", as: :json

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include("error" => "Character not found")
        end

        it "returns a 422 status when an ability score already exists on target character" do
          post "/api/v1/characters/#{@character1.id}/ability_scores", params: { character_ability_score: { ability_id: "str", score: 10 } }, as: :json

          expect(response).to have_http_status(:unprocessable_content)
          expect(JSON.parse(response.body)).to include("error" => "Ability Score already exists for this character")
        end
      end
    end
  end
end
