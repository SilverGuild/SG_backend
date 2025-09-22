require "rails_helper"

RSpec.describe "characters endpoints", type: :request do
  describe "RESTful endpoints" do
    before(:each) do
      @user =  @user1 = User.create!(username: "user1", email: "user1@gmail.com")

      @character1 = Character.create!(name: "Kaelynn Thornwick", 
                                      level: 1, 
                                      experience_points: 0,
                                      alignment: "Neutral Good",
                                      background: "Hermit",
                                      user_id: @user.id)
      @character2 = Character.create!(name: "Theren Nightblade", 
                                      level: 5, 
                                      experience_points: 500,
                                      alignment: "Lawful Evil",
                                      background: "Aristocrate",
                                      user_id: @user.id)
      @character3 = Character.create!(name: "Mira Stormhaven", 
                                      level: 8, 
                                      experience_points: 853,
                                      alignment: "Chaotic Neutral",
                                      background: "Acolyte",
                                      user_id: @user.id)

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

        expect(last_character[:id]).to eq(@character3[:id])
        expect(last_character[:attributes][:name]).to eq(@character3[:name])
        expect(last_character[:attributes][:level]).to eq(@character3[:level])
        expect(last_character[:attributes][:experience_points]).to eq(@character3[:experience_points])
        expect(last_character[:attributes][:alignment]).to eq(@character3[:alignment])
        expect(last_character[:attributes][:background]).to eq(@character3[:background])
        expect(last_character[:attributes][:user_id]).to eq(@character3[:user_id])
      end
    end

     describe "GET /api/v1/users/{ID}" do
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

    describe "POST /api/v1/users" do
      xit "should create a new character and return 201 Created status" do

      end
    end

     describe "PATCH /api/v1/users/{ID}" do
      xit "should updaate a user entry in the db and return successful status" do

      end
    end

    describe "DELETE /api/v1/users/{ID}" do
      xit "should destroy a user by id and return an empty response body" do

      end
    end
  end
end