require "rails_helper"

RSpec.describe ApiErrorHandler, type: :controller do
  controller(ApplicationController) do
    include ApiErrorHandler

    def index
      raise Faraday::ConnectionFailed.new("Connection failed")
    end

    def show
      raise Faraday::TimeoutError.new("Request timeout")
    end
  end

  describe "API error handling" do
    before do
      routes.draw do
        get 'index' => 'anonymous#index'
        get 'show' => 'anonymous#show'
      end
    end

    it "returns a 500 status when dnd5e api connection fails on index" do
      get :index

      expect(response).to have_http_status(:internal_server_error)
      expect(JSON.parse(response.body)).to include("error")
    end

    it "returns a 500 when dnd5e API request times out on show" do
      get :show

      expect(response).to have_http_status(:internal_server_error)
      expect(JSON.parse(response.body)).to include("error")
    end
  end
end
