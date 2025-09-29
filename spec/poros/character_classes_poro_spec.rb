require "rails_helper"

RSpec.describe "Character Class PORO" do
  describe "happy paths" do
    it "should create a new character class poro with all attributes accessible" do
      test_json = {
        name: "monk",
        description: "Meditate on it",
        hit_die: 8,
        skill_proficiencies: [
          {
            "choose" => 2,
            "skills" => [ "acrobatics", "athletics", "history", "insight", "religion", "stealth" ]
          }
        ],
        saving_throw_proficiencies: [ "str", "dex" ]
      }

      monk = CharacterClassPoro.new(test_json)

      expect(monk).to be_an_instance_of CharacterClassPoro
      expect(monk.name).to eq(test_json[:name])
      expect(monk.description).to eq(test_json[:description])
      expect(monk.hit_die).to eq(test_json[:hit_die])
      expect(monk.skill_proficiencies.first[:choose]).to eq(test_json[:skill_proficiencies].first["choose"])
      expect(monk.skill_proficiencies.first[:skills]).to eq(test_json[:skill_proficiencies].first["skills"])
      expect(monk.saving_throw_proficiencies).to eq(test_json[:saving_throw_proficiencies])
    end
  end
end
