require "rails_helper"

RSpec.describe "API::V1::Characters::Skills", type: :request do
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

      @skill1 = CharacterSkill.create!(character: @character1, skill_id: "stealth", proficient: true, expertise: false)
      @skill2 = CharacterSkill.create!(character: @character1, skill_id: "arcane", proficient: false, expertise: false)
    end

    describe "GET /api/v1/characters/:character_id/skills" do
      context "happy paths" do
        it "should retrieve all skills for a character" do
          get "/api/v1/characters/#{@character1.id}/skills"

          expect(response).to be_successful

          json = JSON.parse(response.body, symbolize_names: true)
          skills = json[:data]

          expect(skills.count).to eq(2)

          first_skill = skills.first
          expect(first_skill[:id]).to eq(@skill1[:id])
          expect(first_skill[:attributes][:character_id]).to eq(@skill1[:character_id])
          expect(first_skill[:attributes][:skill_id]).to eq(@skill1[:skill_id])
          expect(first_skill[:attributes][:proficient]).to eq(@skill1[:proficient])
          expect(first_skill[:attributes][:expertise]).to eq(@skill1[:expertise])
        end

        it "only returns skills belonging to the requested character" do
          CharacterSkill.create!(character: @character2, skill_id: "athletic", proficient: true)

          get "/api/v1/characters/#{@character1.id}/skills"

          json = JSON.parse(response.body, symbolize_names: true)

          expect(json[:data].count).to eq(2)
          expect(json[:data].map { |s| s[:attributes][:skill_id] }).not_to include("athletics")
        end
      end

      context "sad paths" do
        it "returns a 404 status when character ID is invalid format" do
          get "/api/v1/characters/invalid/skills"

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Invalid character ID")
        end

        xit "returns a 401 staus when the user is not authenticated" do
        end

        it "returns a 404 status when target character is not found" do
          get "/api/v1/characters/999999999/skills"

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include("error" => "Character not found")
        end

        it "returns a 404 status when the target character has no skills" do
          bare_character = Character.create!(name: "Bare Bones", level: 1, experience_points: 0, alignment: "True Neutral", background: "Folk Hero", user_id: @user.id, character_class_id: "fighter", race_id: "human", subclass_id: "", subrace_id: "", languages: [ "common" ])

          get "/api/v1/characters/#{bare_character.id}/skills"

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include("error" => "No skills were found for this character")
        end
      end
    end

    describe "POST /api/v1/characters/:character_id/skills" do
      context "happy paths" do
        it "should create a new skill for a specific character and return 201 Created Status" do
          test_params = { skill_id: "history", proficient: true, expertise: false }

          post "/api/v1/characters/#{@character1.id}/skills", params: { character_skill: test_params }, as: :json

          expect(response).to have_http_status(:created)

          json = JSON.parse(response.body, symbolize_names: true)
          test_skill = json[:data]

          expect(test_skill[:character_id]).to eq(@character1.id)
          expect(test_skill[:skill_id]).to eq(test_params[:skill_id])
          expect(test_skill[:proficient]).to eq(test_params[:proficient])
          expect(test_skill[:expertise]).to eq(test_params[:expertise])

          # Show that test skill has been added to the existing list of skills
          character = Character.find(@character1.id)
          skills = character.skills
          expect(skills.count).to eq(3)

          last_skill = skills.last
          expect(last_skill[:id]).to eq(test_skill[:id])
        end

        it "allows the same skill_id to exist on a different character" do
          post "/api/v1/characters/#{@character2.id}/skills", params: { character_skill: { skill_id: "stealth", proficient: true } }, as: :json

          expect(response).to have_http_status(:created)
        end
      end

      context "sad paths" do
        it "returns 400 status when character ID is invalid format" do
          post "/api/v1/characters/invalid/skills", as: :json

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Invalid character ID")
        end

        shared_examples "returns 400 for invalid parameter" do |param, invalid_value, error_message |
          it "returns 400 status when #{param} is #{invalid_value.inspect}" do
            test_params = { skill_id: "history", proficient: true, expertise: false }.merge(param => invalid_value)

            post "/api/v1/characters/#{@character1.id}/skills", params: { character_skill: test_params }, as: :json

            expect(response).to have_http_status(:bad_request)
            expect(JSON.parse(response.body)).to include("error" => error_message)
          end
        end

        context "empty/nil parameters" do
          it_behaves_like "returns 400 for invalid parameter", :skill_id, "", "Skill can't be blank"
          it_behaves_like "returns 400 for invalid parameter", :skill_id, nil, "Skill can't be blank"
        end

        context "invalid parameters" do
          it_behaves_like "returns 400 for invalid parameter", :skill_id, "Sleight Of Hand", "Skill is invalid"
          it_behaves_like "returns 400 for invalid parameter", :skill_id, "sleight_of_hand", "Skill is invalid"
          it_behaves_like "returns 400 for invalid parameter", :skill_id, "123", "Skill is invalid"
        end

        it "returns a 400 status when expertise is true without proficiency" do
          post "/api/v1/characters/#{@character1.id}/skills", params: { character_skill: { skill_id: "history", proficient: false, expertise: true } }, as: :json

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Expertise can't be true without proficiency in the skill first")
        end

        xit "returns a 401 status when user is not authenticated" do
        end

        it "returns a 404 status when target character is not found" do
          post "/api/v1/characters/999999999/skills", as: :json

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include("error" => "Character not found")
        end

        it "returns a 422 status when a skill already exists on this character" do
          post "/api/v1/characters/#{@character1.id}/skills", params: { character_skill: { skill_id: "stealth", proficient: true } }, as: :json

          expect(response).to have_http_status(:unprocessable_content)
          expect(JSON.parse(response.body)).to include("error" => "Skill already exists for this character")
        end
      end
    end
  end
end
