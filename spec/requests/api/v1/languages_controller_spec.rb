require "rails_helper"

RSpec.describe "languages endpoints", type: :request do
  describe "RESTful endpoints" do
    describe "GET /api/v1/languages" do
      it "should fetch all languages directly from the dnd5e api" do
        VCR.use_cassette("languages") do
          get "/api/v1/languages"
          expect(response).to be_successful

          json = JSON.parse(response.body, symbolize_names: true)

          langauges = json[:data]
          expect(langauges.count).to eq(16)

          first_language = langauges.first
          last_language = langauges.last

          expect(first_language[:type]).to eq("language")
          expect(first_language[:id]).to eq("abyssal")
          expect(first_language[:attributes][:name]).to eq("Abyssal")
          expect(first_language[:attributes][:url]).to eq("/api/2014/languages/abyssal")

          expect(last_language[:type]).to eq("language")
          expect(last_language[:id]).to eq("undercommon")
          expect(last_language[:attributes][:name]).to eq("Undercommon")
          expect(last_language[:attributes][:url]).to eq("/api/2014/languages/undercommon")
        end
      end
    end

    describe "GET /api/v1/languages/{ID}" do
      it "should fetch a single language by id from the dnd5e api" do
        VCR.use_cassette("language_single_sylvan") do
          target_id = "sylvan"
          get "/api/v1/languages/#{target_id}"

          expect(response).to be_successful

          json = JSON.parse(response.body, symbolize_names: true)
          target = json[:data]

          expect(target[:type]).to eq("language")
          expect(target[:id]).to eq("sylvan")
          expect(target[:attributes][:name]).to eq("Sylvan")
          expect(target[:attributes][:language_type]).to eq("Exotic")
          expect(target[:attributes][:typical_speakers]).to eq([ "Fey creatures" ])
          expect(target[:attributes][:script]).to eq("Elvish")
        end
      end
    end
  end
end
