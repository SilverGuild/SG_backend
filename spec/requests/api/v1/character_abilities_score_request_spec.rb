require 'rails_helper'

RSpec.describe "API::V1::CharacterAbilityScores", type: :request do
  describe "RESTful endpoints" do
    let(:password) { "password123" }

    before(:each) do
      @user = User.create!(username: "user1", email: "user1@gmail.com", password: password)

      @character = Character.create!(name: "Kaelynn Thornwick",
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

      @score1 = CharacterAbilityScore.create!(character: @character, ability_id: "str", score: 14, saving_throw_proficient: true)
      @score2 = CharacterAbilityScore.create!(character: @character, ability_id: "wis", score: 12, saving_throw_proficient: false)

      @target_id = @score2.id
    end

    describe "PATCH /api/character_ability_scores/:id" do
      let(:valid_params) { { score: 16, saving_throw_proficient: true } }

      context "happy paths" do
        it "should update an ability score entry in the db and return successful status" do
          score = CharacterAbilityScore.find(@target_id)

          patch "/api/v1/character_ability_scores/#{@target_id}", params: { character_ability_score: valid_params }, as: :json

          expect(response).to be_successful

          json = JSON.parse(response.body, symbolize_names: true)
          target = json[:data].first

          expect(target[:id]).to eq(score[:id])
          expect(target[:attributes][:character_id]).to eq(score[:character_id])
          expect(target[:attributes][:ability_id]).to eq(score[:ability_id])
          expect(target[:attributes][:score]).to eq(valid_params[:score])
          expect(target[:attributes][:saving_throw_proficient]).to eq(valid_params[:saving_throw_proficient])

          score.reload

          expect(score[:score]).to eq(valid_params[:score])
          expect(score[:saving_throw_proficient]).to be(valid_params[:saving_throw_proficient])
        end
      end

      context "sad paths" do
        it "returns a 400 status when ability score ID is invalid format" do
          patch "/api/v1/character_ability_scores/invalid", params: { character_ability_score: valid_params }, as: :json

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Invalid Ability Score ID")
        end

        shared_examples "returns 400 for invalid parameter" do |param, invalid_value, error_message|
          it "returns 400 when #{param} is #{invalid_value.inspect}" do
            updated_params = { param => invalid_value }

            patch "/api/v1/character_ability_scores/#{@target_id}", params: { character_ability_score: updated_params }, as: :json

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

        it "returns a 400 status when saving_throw_proficient is nil" do
          patch "/api/v1/character_ability_scores/#{@target_id}", params: { character_ability_score: { saving_throw_proficient: nil } }, as: :json

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Saving throw proficient is not included in the list")
        end

        xit "returns a 401 when user is not authenticated" do
        end
        # Will be added with dm access in p2
        xit "returns a 401 status when user (non-owner) does not have a dungeon master access" do
        end

        it "returns a 404 status when target ability score is not found" do
          patch "/api/v1/character_ability_scores/9999999999", params: { character_ability_score: { score: 10 } }, as: :json

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include("error" => "Ability Score not found")
        end

        it "returns a 400 status when attempting to change the ability_id" do
          patch "/api/v1/character_ability_scores/#{@target_id}", params: { character_ability_score: { ability_id: "con" } }, as: :json

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Ability can't be changed after creation")
        end
      end
    end

    describe "DELETE /api/v1/character_ability_scores/:id" do
      context "happy paths" do
        it "should destroy an ability score by id and return an empty response body" do
          expect {
            delete "/api/v1/character_ability_scores/#{@target_id}"
          }.to change(CharacterAbilityScore, :count).by(-1)

          expect(response).to be_successful
          expect(response.body).to be_empty
          expect(CharacterAbilityScore.exists?(@target_id)).to be false
        end
      end

      context "sad paths" do
        it "returns a 400 status when ability score ID is invalid format" do
          delete "/api/v1/character_ability_scores/invalid"

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Invalid Ability Score ID")
        end

        xit "returns a 401 status when user is not authenicated" do
        end
        # Will be added with dm access in p2
        xit "returns a 401 status when user (non-owner) does not have a dungeon master access" do
        end

        it "returns 404 status when target ability score is not found" do
          delete "/api/v1/character_ability_scores/999999999"

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include("error" => "Ability Score not found")
        end
      end
    end
  end
end
