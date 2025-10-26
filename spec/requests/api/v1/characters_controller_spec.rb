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
        expect(target[:attributes][:character_class_id]).to eq(@character2[:character_class_id])
        expect(target[:attributes][:race_id]).to eq(@character2[:race_id])
        expect(target[:attributes][:subclass_id]).to eq(@character2[:subclass_id])
        expect(target[:attributes][:subrace_id]).to eq(@character2[:subrace_id])
        expect(target[:attributes][:languages]).to eq(@character2[:languages])
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
          user_id: @user.id,
          character_class_id: "paladin",
          race_id: "dragonborn",
          subclass_id: "devotion",
          subrace_id: "",
          languages: [ "common", "draconic" ]
        }

        patch "/api/v1/characters/#{@target_id}", params: updated_params

        expect(response).to be_successful

        json = JSON.parse(response.body, symbolize_names: true)

        target = json[:data].first

        expect(target[:id]).to eq(character[:id])
        expect(target[:attributes][:name]).to eq(character[:name])
        expect(target[:attributes][:level]).to eq(updated_params[:level])
        expect(target[:attributes][:experience_points]).to eq(updated_params[:experience_points])
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

        expect(character[:level]).to eq(updated_params[:level])
        expect(character[:experience_points]).to eq(updated_params[:experience_points])
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
