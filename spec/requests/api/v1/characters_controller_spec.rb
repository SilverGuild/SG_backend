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
                                      race_id: "gnome")
      @character2 = Character.create!(name: "Theren Nightblade",
                                      level: 5,
                                      experience_points: 500,
                                      alignment: "Lawful Evil",
                                      background: "Aristocrate",
                                      user_id: @user.id,
                                      character_class_id: "paladin",
                                      race_id: "dragonborn")
      @character3 = Character.create!(name: "Mira Stormhaven",
                                      level: 8,
                                      experience_points: 853,
                                      alignment: "Chaotic Neutral",
                                      background: "Acolyte",
                                      user_id: @user.id,
                                      character_class_id: "fighter",
                                      race_id: "halfling")

      @character4 = Character.create!(name: "Thalorin Emberwick",
                                      level: 7,
                                      experience_points: 755,
                                      alignment: "Lawful Good",
                                      background: "Sage",
                                      user_id: @user2.id,
                                      character_class_name: "cleric",
                                      race_name: "half-elf")

      @target_id = @character2.id
    end

    describe "GET /api/v1/characters" do
      it "should retrieve all characters" do
        get "/api/v1/characters"
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
        expect(first_character[:attributes][:alignment]).to eq(@character1[:alignment])
        expect(first_character[:attributes][:background]).to eq(@character1[:background])
        expect(first_character[:attributes][:user_id]).to eq(@character1[:user_id])

        expect(last_character[:id]).to eq(@character4[:id])
        expect(last_character[:attributes][:name]).to eq(@character4[:name])
        expect(last_character[:attributes][:level]).to eq(@character4[:level])
        expect(last_character[:attributes][:experience_points]).to eq(@character4[:experience_points])
        expect(last_character[:attributes][:alignment]).to eq(@character4[:alignment])
        expect(last_character[:attributes][:background]).to eq(@character4[:background])
        expect(last_character[:attributes][:user_id]).to eq(@character4[:user_id])
      end
    end

     describe "GET /api/v1/characters:id}" do
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
      end
    end

    describe "PATCH /api/v1/characters/:id" do
      it "should updaate a character entry in the db and return successful status" do
        character = Character.find(@target_id)

        updated_params = {
          name: "Theren Nightblade",
          level: 6,
          experience_points: 621,
          alignment: "Lawful Evil",
          background: "Aristocrate",
          user_id: @user.id
        }

        patch "/api/v1/characters/#{@target_id}", params: updated_params

        expect(response).to be_successful

        json = JSON.parse(response.body, symbolize_names: true)

        target = json[:data].first

        expect(target[:id]).to eq(@character2[:id])
        expect(target[:attributes][:name]).to eq(character[:name])
        expect(target[:attributes][:level]).to eq(updated_params[:level])
        expect(target[:attributes][:experience_points]).to eq(updated_params[:experience_points])
        expect(target[:attributes][:alignment]).to eq(character[:alignment])
        expect(target[:attributes][:background]).to eq(character[:background])
        expect(target[:attributes][:user_id]).to eq(character[:user_id])

        # Verify db has updated
        character.reload
        expect(target[:id]).to eq(character[:id])
        expect(target[:attributes][:name]).to eq(character[:name])
        expect(target[:attributes][:level]).to eq(character[:level])
        expect(target[:attributes][:experience_points]).to eq(character[:experience_points])
        expect(target[:attributes][:alignment]).to eq(character[:alignment])
        expect(target[:attributes][:background]).to eq(character[:background])
        expect(target[:attributes][:user_id]).to eq(character[:user_id])
      end
    end

    describe "DELETE /api/v1/characters/:id" do
      it "should destroy a character by id and return an empty response body" do
        expect {
          delete "/api/v1/characters/#{@target_id}"
        }.to change(Character, :count).by(-1)

        expect(response).to be_successful
        expect(response.body).to be_empty
        expect(Character.exists?(@target_id)).to be false
      end
    end
  end
end
