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

    def not_found
      raise ActiveRecord::RecordNotFound.new("Record not found")
    end

    def param_missing
      params.require(:required_key)
    end
  end

  describe "API error handling" do
    before do
      routes.draw do
        get 'index'         => 'anonymous#index'
        get 'show'          => 'anonymous#show'
        get 'not_found'     => 'anonymous#not_found'
        get 'param_missing' => 'anonymous#param_missing'
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

    it "returns a 404 status when a record is not found" do
      get :not_found

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to include("error" => "Resource not found")
    end

    it "returns a 400 status when a required parameter is missing" do
      get :param_missing

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)).to include("error" => "Required parameter missing")
    end
  end
end
