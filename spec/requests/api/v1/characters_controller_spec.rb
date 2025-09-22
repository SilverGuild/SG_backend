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

      end
    end

     describe "GET /api/v1/users/{ID}" do
      it "should retrieve one character" do

      end
    end

    describe "POST /api/v1/users" do
      it "should create a new character and return 201 Created status" do

      end
    end

     describe "PATCH /api/v1/users/{ID}" do
      it "should updaate a user entry in the db and return successful status" do

      end
    end

    describe "DELETE /api/v1/users/{ID}" do
      it "should destroy a user by id and return an empty response body" do

      end
    end
  end
end