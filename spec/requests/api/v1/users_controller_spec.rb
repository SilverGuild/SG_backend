require "rails_helper"

RSpec.describe "API::V1::Users", type: :request do
  describe "RESTful endpoints" do
    before(:each) do
      @user1 = User.create!(username: "user1", email: "user1@gmail.com")
      @user2 = User.create!(username: "user2", email: "user2@gmail.com")
      @user3 = User.create!(username: "user3", email: "user3@gmail.com")

      @target_id = @user2.id
    end

    describe "GET /api/v1/users" do
      context "happy paths" do
        it "retrieves all users from the db" do
          get "/api/v1/users", as: :json

          expect(response).to be_successful

          json = JSON.parse(response.body, symbolize_names: true)

          users = json[:data]
          expect(users.count).to eq(3)

          first_user = users.first
          last_user = users.last

          expect(first_user[:id]).to eq(@user1[:id])
          expect(first_user[:attributes][:username]).to eq(@user1[:username])
          expect(first_user[:attributes][:email]).to eq(@user1[:email])

          expect(last_user[:id]).to eq(@user3[:id])
          expect(last_user[:attributes][:username]).to eq(@user3[:username])
          expect(last_user[:attributes][:email]).to eq(@user3[:email])
        end
      end

      context "sad paths" do
        # Will be added late P1 with authentication and autherization overhaul
        # it "returns a 401 status when user is not authenticated" do

        # end
      end
    end

    describe "GET /api/v1/users/:id" do
      context "happy paths" do
        it "retrieves one user from the db by id" do
          get "/api/v1/users/#{@target_id}", as: :json

          expect(response).to be_successful

          json = JSON.parse(response.body, symbolize_names: true)
          user = json[:data].first
          expect(user[:id]).to eq(@user2.id)
          expect(user[:attributes][:username]).to eq(@user2.username)
          expect(user[:attributes][:email]).to eq(@user2.email)
        end
      end

      context "sad paths" do
        it "returns a 400 status when user ID is invalid format" do
          get "/api/v1/users/invalid", as: :json

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Invalid user ID")
        end

        # Will be added late P1 with authentication and autherization overhaul
        # it "returns a 401 status when user is not authenticated" do

        # end

        it "returns a 404 status when target user is not found" do
          get "/api/v1/users/9999999", as: :json

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include("error" => "User not found")
        end
      end
    end

    describe "POST /api/v1/users" do
      context "happy paths" do
        it "returns 201 status when a new user is created" do
          test_params = {
            username: "test",
            email: "test@gmail.com"
          }

          post "/api/v1/users", params: test_params, as: :json
          expect(response).to have_http_status(:created)

          json = JSON.parse(response.body, symbolize_names: true)
          test_user = json[:data]
          expect(test_user[:username]).to eq(test_params[:username])
          expect(test_user[:email]).to eq(test_params[:email])

          # Show that the new user is added to existing list of users in the db
          users = User.all

          expect(users.count).to eq(4)

          last_user = users.last

          expect(last_user[:id]).to eq(test_user[:id])
        end
      end

      context "sad paths" do
        it "returns a 400 status when username parameter is missing" do
          bad_test_params = {
            # Username parameter missing entirely
            email: "test@gmail.com"
          }

          post "/api/v1/users", params: bad_test_params, as: :json
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Username is missing")
        end
        it "returns a 400 status when email parameter is missing" do
          bad_test_params = {
            username: "test",
            # Email parameter missing entirely
          }

          post "/api/v1/users", params: bad_test_params, as: :json
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Email is missing")
        end

        it "returns a 400 status when username parameter is empty" do
          bad_test_params = {
            username: "",
            email: "test@gmail.com"
          }

          post "/api/v1/users", params: bad_test_params, as: :json
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Username is empty")
        end

        it "returns a 400 status when email parameter is empty" do
          bad_test_params = {
            username: "test",
            email: ""
          }

          post "/api/v1/users", params: bad_test_params, as: :json
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Email is empty")
        end

        it "returns a 400 status when email parameter is invalid format" do
          bad_test_params = {
            username: "test",
            email: "email.bad_test@com"
          }

          post "/api/v1/users", params: bad_test_params, as: :json
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Email is an invalid format")
        end

        # Will be added late P1 with authentication and autherization overhaul
        # it "returns a 401 status when user is not authenticated" do

        # end

        it "returns a 422 status when a user already exists in the db" do
          # Original user -> full duplicate
          test_user = {
            username: "test",
            email: "test@gmail.com"
          } 

          # Duplicate with username
          dup_user1 = {
            username: "test",
            email: "duptest1@gmail.com"
          }

          # Duplicate with email
          dup_user2 = {
            username: "duptest2",
            email: "test@gmail.com"
          }
 
          post "/api/v1/users", params: test_user, as: :json
          expect(response).to be_successful

          post "/api/v1/users", params: test_user, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to include("error" => "User already exists")

          post "/api/v1/users", params: dup_user1, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to include("error" => "User already exists with this username")

          post "/api/v1/users", params: dup_user2, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to include("error" => "User already exists with this email")
        end
      end
    end

    describe "PATCH /api/v1/users/:id" do
      context "happy paths" do
        it "returns a 200 status and updates the target user entry in the db" do
          user = User.find(@target_id)

          updated_params = {
            username: "user2",
            email: "user2_0@gmail.com"
          }

          patch "/api/v1/users/#{@target_id}", params: { user: updated_params }, as: :json

          expect(response).to be_successful

          json = JSON.parse(response.body, symbolize_names: true)
          target = json[:data].first

          expect(target[:attributes][:username]).to eq("user2")
          expect(target[:attributes][:email]).to eq("user2_0@gmail.com")

          # Verify db was updated
          user.reload
          expect(user[:username]).to eq("user2")
          expect(user[:email]).to eq("user2_0@gmail.com")
        end
      end

      context "sad paths" do
        it "returns a 400 status when user ID is invalid format" do
          updated_params = {
            username: "user2",
            email: "user2_0@gmail.com"
          }

          patch "/api/v1/users/invalid", params: { user: updated_params }, as: :json

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Invalid user ID")
        end

        it "returns a 400 status when username parameter is empty" do
          bad_test_params = {
            username: ""
          }

          patch "/api/v1/users/#{@target_id}", params: { user: bad_test_params }, as: :json
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Username is empty")
        end
        
        it "returns a 400 status when email parameter is empty" do
          bad_test_params = {
            email: ""
          }

          patch "/api/v1/users/#{@target_id}", params: { user: bad_test_params }, as: :json
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Email is empty")
        end

        it "returns a 400 status when a parameter is invalid format" do
          test_params = {
            email: "dup.email@com"
          }

          patch "/api/v1/users/#{@target_id}", params: { user: test_params }, as: :json

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Email is an invalid format")
        end

        # Will be added late P1 with authentication and autherization overhaul
        # it "returns a 401 status when user is not authenticated" do

        # end

        it "returns a 404 error when the target user does not exist" do
          test_params = {
            email: "dupped@gmail.com"
          }

          patch "/api/v1/users/9999999", params: { user: test_params }, as: :json

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include("error" => "User not found")
        end

         it "returns a 422 status when updating to a username that already exists" do
          test_params = {
            username: "user1"
          }

          patch "/api/v1/users/#{@target_id}", params: { user: test_params }, as: :json

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to include("error" => "Username already exists")
        end
        
        it "returns a 422 status when updating to an email that already exists" do
          test_params = {
            email: "user1@gmail.com"
          }

          patch "/api/v1/users/#{@target_id}", params: { user: test_params }, as: :json

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to include("error" => "Email already exists")
        end
      end
    end

    describe "DELETE /api/v1/users/:id" do
      context "happy paths" do
        it "should destroy a user by id and return an empty response body" do
          expect {
            delete "/api/v1/users/#{@target_id}", as: :json
          }.to change(User, :count).by(-1)

          expect(response).to have_http_status(:no_content)
          expect(response.body).to be_empty
          expect(User.exists?(@target_id)).to be false
        end
      end

      context "sad paths" do
        it "returns a 400 status when user ID is invalid format" do
          delete "/api/v1/users/invalid", as: :json

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include("error" => "Invalid user ID")
        end
        
        # Will be added late P1 with authentication and autherization overhaul
        # it "returns a 401 status when user is not authenticated" do

        # end

        it "returns a 404 error when the target user does not exist" do
          delete "/api/v1/users/9999999", as: :json

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include("error" => "User not found")
        end
      end
    end
  end
end
