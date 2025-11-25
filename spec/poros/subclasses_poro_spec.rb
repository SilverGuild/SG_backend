require "rails_helper"

RSpec.describe "Subclass PORO" do
  describe "happy paths" do
    it "should create a new subclass poro with all attributes accessible" do
      VCR.use_cassette("subclass_hunter") do
        response = Faraday.get("https://www.dnd5eapi.co/api/2014/subclasses/hunter")
        test_response = JSON.parse(response.body, symbolize_names: true)

        hunter = SubclassPoro.new(test_response)

        expect(hunter).to be_an_instance_of SubclassPoro
        expect(hunter.id).to eq("hunter")
        expect(hunter.name).to eq("Hunter")
        expect(hunter.flavor).to eq("Ranger Archetype")
        expect(hunter.class_id).to eq("ranger")
        expect(hunter.description).to eq("Emulating the Hunter archetype means accepting your place as a bulwark between civilization and the terrors of the wilderness. As you walk the Hunter's path, you learn specialized techniques for fighting the threats you face, from rampaging ogres and hordes of orcs to towering giants and terrifying dragons.")
      end
    end
  end
end
