require "rails_helper"

RSpec.describe "API::V1::Sessions", type: :request do
  # has+secure+password now requires a password at creation, so seed the auth
  # user with a known password we can authenticate against.
  let(:password) { "password123" }

  before(:each) do
    @user = User.create!(
      username: "tav",
      email: "tav@silverguild.test",
      password: password
    )
  end

  describe "POST /api/v1/login" do
    context "happy paths" do
      it "logs in with valid credentials and starts a session" do
        post "/api/v1/login", params: { session: { username: @user.username, password: password } }, as: :json

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body, symbolize_names: true)
        userData = json[:data].first[:attributes]

        expect(userData[:username]).to eq(@user.username)
        expect(userData[:email]).to eq(@user.email)

        # session cookie now recognizes this user
        expect(session[:user_id]).to eq(@user.id)
      end

      it "does not leak the password digest in the response" do
        post "/api/v1/login", params: { session: { username: @user.username, password: password } }, as: :json

        expect(response.body).not_to include("password_digest")
      end
    end

    context "sad paths" do
      it "returns a generic 401 when the password is wrong" do
        post "/api/v1/login", params: { session: { username: @user.username, password: "wrong" } }, as: :json

        expect(response).to have_http_status(:unauthorized)

        json = JSON.parse(response.body)

        expect(json).to include("error" => "Invalid username or password")
        expect(session[:user_id]).to be_nil
      end

      it "returns the same generic 401 when the username does not exist" do
        post "/api/v1/login", params: { session: { username: "ghost", password: password } }, as: :json

        expect(response).to have_http_status(:unauthorized)
        
        json = JSON.parse(response.body)
        
        # identical message to the wrong-password case - must not reveal whether the user exists
        expect(json).to include("error" => "Invalid username or password")
        expect(session[:user_id]).to be_nil
      end
      
      it "is case-sensitive on username" do
        post "/api/v1/login", params: { session: { username: @user.username.upcase, password: password } }, as: :json
        
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns 400 when session param is missing entirely" do
        post "/api/v1/login", params: {}, as: :json

        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe "GET /api/v1/current" do
    context "happy paths" do
      it "returns the current user when a session is active" do
          post "/api/v1/login", params: { session: { username: @user.username,password: password } }, as: :json

          get "/api/v1/current", as: :json

          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body, symbolize_names: true)
          expect(json[:data].first[:attributes][:username]).to eq(@user.username)
      end
    end

    context "sad paths" do
      it "returns 401 when there is no active session" do
        get "/api/v1/current", as: :json

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to include("error" => "Not authenticated")
      end
    end
  end

  describe "DELETE /api/v1/logout" do
    context "happy paths" do
      it "clears the session and returns 204" do
        post "/api/v1/login", params: { session: { username: @user.username, password: password } }, as: :json
        
        expect(session[:user_id]).to eq(@user.id)

        delete "/api/v1/logout", as: :json

        expect(response).to have_http_status(:no_content)
        expect(response.body).to be_empty
        expect(session[:user_id]).to be_nil
      end

      it "makes a subsequent /current return 401" do
        post "/api/v1/login",
          params: { session: { username: @user.username, password: password } },
          as: :json

        delete "/api/v1/logout", as: :json

        get "/api/v1/current", as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end 
end