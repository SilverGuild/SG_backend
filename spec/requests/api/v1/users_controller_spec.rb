require "rails_helper"

RSpec.describe "users endpoints", type: :request do

  describe "Happy Paths" do
    before(:each) do
      @user1 = User.create!(username: "user1", email: "user1@gmail.com")
      @user2 = User.create!(username: "user2", email: "user2@gmail.com")
      @user3 = User.create!(username: "user3", email: "user3@gmail.com")

      @target_id = @user2.id
    end

    it "should retrieve all users" do
      get "/api/v1/users"
      expect(response).to be_successful
      
      json = JSON.parse(response.body, symbolize_names: true)
      
      users = json[:data]
      expect(users.count).to eq(3)
      
      first_user = users.first
      last_user = users.last
      
      expect(first_user[:id]).to eq(@user1.id)
      expect(first_user[:attributes][:username]).to eq(@user1.username)
      expect(first_user[:attributes][:email]).to eq(@user1.email)
      
      expect(last_user[:id]).to eq(@user3[:id])
      expect(last_user[:attributes][:username]).to eq(@user3.username)
      expect(last_user[:attributes][:email]).to eq(@user3.email)
    end

    it "should retrieve one user" do
      get "/api/v1/users/#{@target_id}"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)
      user = json[:data].first
      expect(user[:id]).to eq(@user2.id)
      expect(user[:attributes][:username]).to eq(@user2.username)
      expect(user[:attributes][:email]).to eq(@user2.email)
    end

    it "should create a new user and return 201 Created status" do
      test_params = {
        username: "test",
        email: "test@gmail.com"
      }

      post "/api/v1/users/", params: test_params, as: :json

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body, symbolize_names: true)
      test_user = json[:data]
      expect(test_user[:username]).to eq(test_params[:username])
      expect(test_user[:email]).to eq(test_params[:email])

      # Show that it is added to existing list of users
      users = User.all

      expect(users.count).to eq(4)

      last_user = users.last

      expect(last_user[:id]).to eq(test_user[:id])
    end 

    it "should updaate a user attribute and return successful status" do
      updated_params = {
        username: "user2",
        email: "user2_0@gmail.com"
      }

      patch "/api/v1/users/#{@target_id}", params: updated_params

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)
      target = json[:data]
      expect(target[:attributes][:username]).to eq("user2")
      expect(target[:attributes][:email]).to eq("user2_0@gmail.com")

      user.reload
      expect(user.username).to eq("user2")
      expect(user.email).to eq("user2_0@gmail.com")
    end

    xit "should destroy a user by id and return a 200 succussful status" do
      patch 
    end
  end
end
