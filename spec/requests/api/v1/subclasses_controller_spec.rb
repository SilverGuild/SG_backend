require "rails_helper"

RSpec.describe "API::V1::Subclasses", type: :request do
  describe "RESTful endpoints" do
    describe "GET /api/v1/subclasses" do
      it "should retrieve all subclasses directly from dnd5e api" do
        VCR.use_cassette("subclasses") do
          get "/api/v1/subclasses"
          expect(response).to be_successful

          json = JSON.parse(response.body, symbolize_names: true)

          subclasses = json[:data]
          expect(subclasses.count).to eq(12)

          first_subclass = subclasses.first
          last_subclass = subclasses.last

          expect(first_subclass[:type]).to eq("subclass")
          expect(first_subclass[:id]).to eq("berserker")
          expect(first_subclass[:attributes][:name]).to eq("Berserker")
          expect(first_subclass[:attributes][:url]).to eq("/api/2014/subclasses/berserker")

          expect(last_subclass[:type]).to eq("subclass")
          expect(last_subclass[:id]).to eq("thief")
          expect(last_subclass[:attributes][:name]).to eq("Thief")
          expect(last_subclass[:attributes][:url]).to eq("/api/2014/subclasses/thief")
        end
      end
    end

    describe "GET /api/v1/subclasses/:id" do
      describe "happy paths" do
        it "should retrieve one subclass by id from dnd5e api" do
          VCR.use_cassette("subclasses_fiend") do
            target_id = "fiend"
            get "/api/v1/subclasses/#{target_id}"

            expect(response).to be_successful

            json = JSON.parse(response.body, symbolize_names: true)
            target = json[:data]

            expect(target[:type]).to eq("subclass")
            expect(target[:id]).to eq("fiend")
            expect(target[:attributes][:name]).to eq("Fiend")
            expect(target[:attributes][:flavor]).to eq("Otherworldly Patron")
            expect(target[:attributes][:class_id]).to eq("warlock")
            expect(target[:attributes][:description]).to eq("You have made a pact with a fiend from the lower planes of existence, a being whose aims are evil, even if you strive against those aims. Such beings desire the corruption or destruction of all things, ultimately including you. Fiends powerful enough to forge a pact include demon lords such as Demogorgon, Orcus, Fraz'Urb-luu, and Baphomet; archdevils such as Asmodeus, Dispater, Mephistopheles, and Belial; pit fiends and balors that are especially mighty; and ultroloths and other lords of the yugoloths.")
          end
        end
      end

      describe "sad paths" do
        before do
          stub_request(:get, "https://www.dnd5eapi.co/api/2014/subclasses/test").to_return(status: 404, body: { error: "Not found" }.to_json)
        end

        it "returns a 404 status when target race does not exist" do
          get "/api/v1/subclasses/test"

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to include("error" => "Subclass not found")
        end
      end
    end
  end
end
