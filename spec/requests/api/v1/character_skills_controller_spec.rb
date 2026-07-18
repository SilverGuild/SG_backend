require 'rails_helper'

RSpec.describe "API::V1::CharacterSkills", type: :request do
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

      @skill1 = CharacterSkill.create!(character: @character, skill_id: "stealth", proficient: true, expertise: false)
      @skill2 = CharacterSkill.create!(character: @character, skill_id: "arcane", proficient: false, expertise: false)

      @target_id = @skill2.id
    end
    describe "PATCH /api/v1/characterskills/:id" do
      let(:valid_params) { { proficient: true, expertise: true } }

      context "happy paths" do
        it "should update a skill entry in the db and return successful status" do
          skill = CharacterSkill.find(@target_id)

          patch "/api/v1/character_skills/#{@target_id}", params: { character_skill: valid_params }, as: :json

          expect(response).to be_successful

          json = JSON.parse(response.body, symbolize_names: true)
          target = json[:data].first

          expect(target[:id]).to eq(skill[:id])
          expect(target[:attributes][:character_id]).to eq(skill[:character_id])
          expect(target[:attributes][:skill_id]).to eq(skill[:skill_id])
          expect(target[:attributes][:proficient]).to eq(valid_params[:proficient])
          expect(target[:attributes][:expertise]).to eq(valid_params[:expertise])

          skill.reload

          expect(skill[:proficient]).to be(valid_params[:proficient])
          expect(skill[:expertise]).to be(valid_params[:expertise])
        end
      end

      context "sad paths" do
        it "returns a 400 status when skill ID is invalid format" do
            patch "/api/v1/character_skills/invalid", params: { character_skill: valid_params }, as: :json

            expect(response).to have_http_status(:bad_request)
            expect(JSON.parse(response.body)).to include("error" => "Invalid skill ID")
        end

        shared_examples "returns 400 for invalid parameter" do |param, invalid_value, error_message|
          it "returns 400 when #{param} is #{invalid_value.inspect}" do
            updated_params = { param => invalid_value }

            patch "/api/v1/character_skills/#{@target_id}", params: { character_skill: updated_params }, as: :json

            expect(response).to have_http_status(:bad_request)
            expect(JSON.parse(response.body)).to include("error" => error_message)
          end
        end

        context "empty/nil parameters" do
          it_behaves_like "returns 400 for invalid parameter", :skill_id, "", "Skill can't be blank"
          it_behaves_like "returns 400 for invalid parameter", :skill_id, nil, "Skill can't be blank"
        end

        context "invalid parameters" do
          it_behaves_like "returns 400 for invalid parameter", :skill_id, "Sleight of Hand", "Skill is invalid"
          it_behaves_like "returns 400 for invalid parameter", :skill_id, "sleight_of_hand", "Skill is invalid"
        end

        it "returns a 400 status when expertise is set true without proficiency" do
          patch "/api/v1/character_skills/#{@target_id}", params: { character_skill: { proficient: false, expertise: true } }, as: :json

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Expertise can't be true without proficiency in the skill first")
        end

        xit "returns a 401 status when user is not authenticated" do
        end
        # Will be added with dm access in p2
        xit "returns a 401 status when user (non-owner) does not have a dungeon master access" do
        end

        it "returns a 404 status when target skill is not found" do
          patch "/api/v1/character_skills/99999999999", params: { character_skills: { proficient: true } }, as: :json

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include("error" => "Skill not found")
        end

        it "returns a 400 status when attempting to change the skill_id" do
          patch "/api/v1/character_skills/#{@target_id}", params: { character_skill: { skill_id: "hisotry" } }, as: :json

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Skill can't be changed after creation")
        end
      end
    end

    describe "DELETE /api/v1/character_skills/:id" do
      context "happy paths" do
        it "should destroy a skill by id and return an empty response body" do
          expect {
            delete "/api/v1/character_skills/#{@target_id}"
        }.to change(CharacterSkill, :count).by(-1)

        expect(response).to be_successful
        expect(response.body).to be_empty
        expect(CharacterSkill.exists?(@target_id)).to be false
        end
      end

      context "sad paths" do
        it "returns a 400 status when skill ID is invalid format" do
          delete "/api/v1/character_skills/invalid"

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Invalid skill ID")
        end

        xit "returns a 401 status when user is not authenticated" do
        end

        # Will be added with dm access in p2
        xit "returns a 401 status when user (non-owner) does not have a dungeon master access" do
        end

        it "returns a 404 status when target skill is not found" do
          delete "/api/v1/character_skills/999999999", as: :json

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include("error" => "Skill not found")
        end
      end
    end
  end
end
