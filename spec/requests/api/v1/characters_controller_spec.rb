require "rails_helper"

RSpec.describe "API::V1::Characters", type: :request do
  describe "RESTful endpoints" do
    before(:each) do
      @user = User.create!(username: "user1", email: "user1@gmail.com")

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
      @character3 = Character.create!(name: "Mira Stormhaven",
                                      level: 8,
                                      experience_points: 853,
                                      alignment: "Chaotic Neutral",
                                      background: "Acolyte",
                                      user_id: @user.id,
                                      character_class_id: "fighter",
                                      race_id: "halfling",
                                      subclass_id: "champion",
                                      subrace_id: "lightfoot-halfling",
                                      languages: [ "common", "halfling" ])
      @character4 = Character.create!(name: "Thalorin Emberwick",
                                      level: 7,
                                      experience_points: 755,
                                      alignment: "Lawful Good",
                                      background: "Sage",
                                      user_id: @user.id,
                                      character_class_id: "cleric",
                                      race_id: "half-elf",
                                      subclass_id: "life",
                                      subrace_id: "",
                                      languages: [ "common", "elvish" ])

      @target_id = @character2.id
    end

    describe "GET /api/v1/characters" do
      context "happy paths" do
        it "should retrieve all characters" do
          get "/api/v1/characters"
          expect(response).to be_successful

          json = JSON.parse(response.body, symbolize_names: true)

          characters = json[:data]
          expect(characters.count).to eq(4)

          first_character = characters.first
          last_character = characters.last

          expect(first_character[:id]).to eq(@character1[:id])
          expect(first_character[:attributes][:name]).to eq(@character1[:name])
          expect(first_character[:attributes][:level]).to eq(@character1[:level])
          expect(first_character[:attributes][:experience_points]).to eq(@character1[:experience_points])
          expect(first_character[:attributes][:alignment]).to eq(@character1[:alignment])
          expect(first_character[:attributes][:background]).to eq(@character1[:background])
          expect(first_character[:attributes][:user_id]).to eq(@character1[:user_id])
          expect(first_character[:attributes][:character_class_id]).to eq(@character1[:character_class_id])
          expect(first_character[:attributes][:race_id]).to eq(@character1[:race_id])
          expect(first_character[:attributes][:subclass_id]).to eq(@character1[:subclass_id])
          expect(first_character[:attributes][:subrace_id]).to eq(@character1[:subrace_id])
          expect(first_character[:attributes][:languages]).to eq(@character1[:languages])

          expect(last_character[:id]).to eq(@character4[:id])
          expect(last_character[:attributes][:name]).to eq(@character4[:name])
          expect(last_character[:attributes][:level]).to eq(@character4[:level])
          expect(last_character[:attributes][:experience_points]).to eq(@character4[:experience_points])
          expect(last_character[:attributes][:alignment]).to eq(@character4[:alignment])
          expect(last_character[:attributes][:background]).to eq(@character4[:background])
          expect(last_character[:attributes][:user_id]).to eq(@character4[:user_id])
          expect(last_character[:attributes][:character_class_id]).to eq(@character4[:character_class_id])
          expect(last_character[:attributes][:race_id]).to eq(@character4[:race_id])
          expect(last_character[:attributes][:subclass_id]).to eq(@character4[:subclass_id])
          expect(last_character[:attributes][:subrace_id]).to eq(@character4[:subrace_id])
          expect(last_character[:attributes][:languages]).to eq(@character4[:languages])
        end
      end

      context "sad paths" do
        # Will be added late P1 with authentication and autherization overhaul **********
        # it "returns a 401 status when user is not authenticated" do

        # end

        # it "returns a 401 status when user (non-owner) does not have dungeon master access" do

        # end
        # ***********
      end
    end

    describe "GET /api/v1/characters:id}" do
      context "happy paths" do
        it "should retrieve one character" do
          get "/api/v1/characters/#{@target_id}"
          expect(response).to be_successful

          json = JSON.parse(response.body, symbolize_names: true)

          target = json[:data].first

          expect(target[:id]).to eq(@character2[:id])
          expect(target[:attributes][:name]).to eq(@character2[:name])
          expect(target[:attributes][:level]).to eq(@character2[:level])
          expect(target[:attributes][:experience_points]).to eq(@character2[:experience_points])
          expect(target[:attributes][:alignment]).to eq(@character2[:alignment])
          expect(target[:attributes][:background]).to eq(@character2[:background])
          expect(target[:attributes][:user_id]).to eq(@character2[:user_id])
          expect(target[:attributes][:character_class_id]).to eq(@character2[:character_class_id])
          expect(target[:attributes][:race_id]).to eq(@character2[:race_id])
          expect(target[:attributes][:subclass_id]).to eq(@character2[:subclass_id])
          expect(target[:attributes][:subrace_id]).to eq(@character2[:subrace_id])
          expect(target[:attributes][:languages]).to eq(@character2[:languages])
        end
      end

      context "sad paths" do
        it "returns a 400 status when character ID is invalid format" do
          get "/api/v1/characters/invalid", as: :json

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Invalid character ID")
        end

        # Will be added late P1 with authentication and autherization overhaul **********
        # it "returns a 401 status when user is not authenticated" do

        # end

        # it "returns a 401 status when user (non-owner) does not have dungeon master access" do

        # end
        # ***********

        it "returns a 404 status when target character is not found" do
          get "/api/v1/characters/9999999", as: :json

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include("error" => "Character not found")
        end
      end
    end

    describe "PATCH /api/v1/characters/:id" do
      let(:valid_params) do
        {
          name: "Theren Nightblade",
          level: 6,
          experience_points: 621,
          alignment: "Lawful Evil",
          background: "Aristocrate",
          user_id: @user.id,
          character_class_id: "paladin",
          race_id: "dragonborn",
          subclass_id: "devotion",
          subrace_id: "",
          languages: [ "common", "draconic" ]
        }
      end

      context "happy paths" do
        it "should updaate a character entry in the db and return successful status" do
          character = Character.find(@target_id)

          patch "/api/v1/characters/#{@target_id}", params: { character: valid_params }, as: :json

          expect(response).to be_successful

          json = JSON.parse(response.body, symbolize_names: true)

          target = json[:data].first

          expect(target[:id]).to eq(character[:id])
          expect(target[:attributes][:name]).to eq(character[:name])
          expect(target[:attributes][:level]).to eq(valid_params[:level])
          expect(target[:attributes][:experience_points]).to eq(valid_params[:experience_points])
          expect(target[:attributes][:alignment]).to eq(character[:alignment])
          expect(target[:attributes][:background]).to eq(character[:background])
          expect(target[:attributes][:user_id]).to eq(character[:user_id])
          expect(target[:attributes][:character_class_id]).to eq(character[:character_class_id])
          expect(target[:attributes][:race_id]).to eq(character[:race_id])
          expect(target[:attributes][:subclass_id]).to eq(character[:subclass_id])
          expect(target[:attributes][:subrace_id]).to eq(character[:subrace_id])
          expect(target[:attributes][:languages]).to eq(character[:languages])

          # Verify db has updated specific attributes
          character.reload

          expect(character[:level]).to eq(valid_params[:level])
          expect(character[:experience_points]).to eq(valid_params[:experience_points])
        end
      end

      context "sad paths" do
        it "returns a 400 status when character ID is invalid format" do
          patch "/api/v1/characters/invalid", params: { character: :valid_params }, as: :json

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Invalid character ID")
        end

        shared_examples "returns 400 for invalid parameter" do |param, invalid_value, error_message|
          it "returns 400 when #{param} is #{invalid_value.inspect}" do
            updated_params = { param => invalid_value }

            patch "/api/v1/characters/#{@target_id}", params: { character: updated_params }, as: :json

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

          it_behaves_like "returns 400 for invalid parameter", :user_id, nil, "User must exist"

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
          it_behaves_like "returns 400 for invalid parameter", :user_id, "ghi", "User must exist"
          it_behaves_like "returns 400 for invalid parameter", :character_class_id, 1011, "Character class is invalid"
          it_behaves_like "returns 400 for invalid parameter", :race_id, 1213, "Race is invalid"
          it_behaves_like "returns 400 for invalid parameter", :subclass_id, 1415, "Subclass is invalid"
          it_behaves_like "returns 400 for invalid parameter", :subrace_id, 1617, "Subrace is invalid"
        end

        # Will be added late P1 with authentication and autherization overhaul **********
        # it "returns a 401 status when user is not authenticated" do

        # end

        # it "returns a 401 status when user (non-owner) does not have dungeon master access" do

        # end
        # ***********

        it "returns a 404 status when target character is not found" do
          patch "/api/v1/characters/99999999", params: { character: { level: 6,
            experience_points: 621 } }, as: :json

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include("error" => "Character not found")
        end

        it "returns a 422 status when updating to a name that already exists" do
          patch "/api/v1/characters/#{@target_id}", params: { character: { name: "Kaelynn Thornwick" } }, as: :json

          expect(response).to have_http_status(:unprocessable_content)
          expect(JSON.parse(response.body)).to include("error" => "Character already exists with this name")
        end
      end
    end

    describe "DELETE /api/v1/characters/:id" do
      context "happy paths" do
        it "should destroy a character by id and return an empty response body" do
          expect {
            delete "/api/v1/characters/#{@target_id}"
          }.to change(Character, :count).by(-1)

          expect(response).to be_successful
          expect(response.body).to be_empty
          expect(Character.exists?(@target_id)).to be false
        end
      end

      context "sad paths" do
        it "returns a 400 status when character ID is invalid format" do
          delete "/api/v1/characters/invalid", as: :json

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Invalid character ID")
        end

        # Will be added late P1 with authentication and autherization overhaul **********
        # it "returns a 401 status when user is not authenticated" do

        # end

        # it "returns a 401 status when user (non-owner) does not have dungeon master access" do

        # end
        # ***********

        it "returns a 404 status when target character is not found" do
          delete "/api/v1/characters/99999999", as: :json

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include("error" => "Character not found")
        end
      end
    end
  end
end
