require "rails_helper"

RSpec.describe "Subrace PORO" do
  describe "happy paths" do
    it "should create a new subrace with all attributes accessible" do
      VCR.use_cassette("subrace_poro_high_elf") do
        response = Faraday.get("https://www.dnd5eapi.co/api/2014/subraces/high-elf")
        test_response = JSON.parse(response.body, symbolize_names: true)

        high_elf = SubracePoro.new(test_response)

        expect(high_elf).to be_an_instance_of SubracePoro
        expect(high_elf.id).to eq("high-elf")
        expect(high_elf.name).to eq("High Elf")
        expect(high_elf.race_id).to eq("elf")
        expect(high_elf.description).to eq("As a high elf, you have a keen mind and a mastery of at least the basics of magic. In many fantasy gaming worlds, there are two kinds of high elves. One type is haughty and reclusive, believing themselves to be superior to non-elves and even other elves. The other type is more common and more friendly, and often encountered among humans and other races.")
        expect(high_elf.ability_bonuses.first[:ability_score][:name]).to eq("INT")
        expect(high_elf.ability_bonuses.first[:bonus]).to eq(1)
        expect(high_elf.url).to eq("/api/2014/subraces/high-elf")
      end
    end
  end
end
