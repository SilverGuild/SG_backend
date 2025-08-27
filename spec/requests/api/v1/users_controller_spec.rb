require "rails_helper"

RSpec.describe "users endpoints", type: :request do

  describe "Happy Paths" do
    before(:each) do
      @user1 = User.create(username: "user1", email: "user1@gmail.com")
      @user2 = User.create(username: "user2", email: "user2@gmail.com")
      @user3 = User.create(username: "user3", email: "user3@gmail.com")
    end

    it "should retrieve all users" do

      get "/api/v1/users"
      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      users = json[:data]
      expect(users.count).to eq(3)
    
      first_user = users.first
      last_user = users.last

      expect(first_user[:id]).to eq(@user1[:id])
      expect(first_user[:attributes][:username]).to eq(@user1[:username])
      expect(first_user[:attributes][:email]).to eq(@user1[:email])
      
      expect(last_user[:id]).to eq(@user3.id)
      expect(last_user[:username]).to eq(@user3[:username])
      expect(last_user[:email]).to eq(@user3[email])
    end

    xit "should create a new user" do
       bob = User.create(username: "Bob3", email: "bob3@gmail.com")
    end

    xit "should retrieve one user" do
    end
  end
end
