require "rails_helper"

RSpec.describe "API::V1::Users::Characters", type: :request do
  describe "RESTful endpoints" do
    before(:each) do
      @user = User.create!(username: "user1", email: "user1@gmail.com")

      @character1 = Character.create!(name: "Kaelynn Thornwick",
                                      level: 1,
                                      experience_points: 0,
                                      alignment: "Neutral Good",
                                      background: "Hermit",
                                      user_id: @user.id,
                                      character_class_name: "druid",
                                      race_name: "gnome")
      @character2 = Character.create!(name: "Theren Nightblade",
                                      level: 5,
                                      experience_points: 500,
                                      alignment: "Lawful Evil",
                                      background: "Aristocrate",
                                      user_id: @user.id,
                                      character_class_name: "paladin",
                                      race_name: "dragonborn")
      @character3 = Character.create!(name: "Mira Stormhaven",
                                      level: 8,
                                      experience_points: 853,
                                      alignment: "Chaotic Neutral",
                                      background: "Acolyte",
                                      user_id: @user.id,
                                      character_class_name: "fighter",
                                      race_name: "halfling")
    end
    describe "GET /api/v1/users/:id/characters" do
      it "should retrieve all a users characters" do
        get "/api/v1/users/#{@user.id}/characters"
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

        expect(last_character[:id]).to eq(@character3[:id])
        expect(last_character[:attributes][:name]).to eq(@character3[:name])
        expect(last_character[:attributes][:level]).to eq(@character3[:level])
        expect(last_character[:attributes][:experience_points]).to eq(@character3[:experience_points])
        expect(last_character[:attributes][:alignment]).to eq(@character3[:alignment])
        expect(last_character[:attributes][:background]).to eq(@character3[:background])
        expect(last_character[:attributes][:user_id]).to eq(@character3[:user_id])
      end
    end

    describe "POST /api/v1/users/:id/characters" do
      it "should create a new character for a specific user and return 201 Created status" do
        test_params = {
          name: "Theren Nightwhisper",
          level: 3,
          experience_points: 345,
          alignment: "Chaotic Good",
          background: "Folk Hero",
          user_id: @user.id,
          character_class_name: "wizard",
          race_name: "half-elf"
        }

        post "/api/v1/users/#{@user.id}/characters", params: test_params, as: :json
        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body, symbolize_names: true)
        test_character = json[:data]

        expect(test_character[:name]).to eq(test_params[:name])
        expect(test_character[:level]).to eq(test_params[:level])
        expect(test_character[:experience_points]).to eq(test_params[:experience_points])
        expect(test_character[:alignment]).to eq(test_params[:alignment])
        expect(test_character[:background]).to eq(test_params[:background])
        expect(test_character[:user_id]).to eq(test_params[:user_id])
        expect(test_character[:character_class_name]).to eq(test_params[:character_class_name])
        expect(test_character[:race_name]).to eq(test_params[:race_name])

        # Show that test_character has been added to the existing lsit of characters
        user = User.find(@user.id)
        characters = user.characters
        expect(characters.count).to eq(4)

        last_character = characters.last
        expect(last_character[:id]).to eq(test_character[:id])
      end
    end
  end
end
