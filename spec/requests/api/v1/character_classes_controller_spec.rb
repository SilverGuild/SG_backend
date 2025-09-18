require "rails_helper"

RSpec.describe "character_classes endpoints", type: :request do
  describe "RESTful endpoints" do
    before(:each) do
      @class1 = CharacterClass.create!(name: "Sorcerer",
                                        description: "A magic user",
                                        hit_die: 6,
                                        skill_proficiencies: [ {
                                          "choose" => 2,
                                          "skills" => [ "arcana", "deception", "insight", "intimidation", "persuasion", "religion" ]
                                        } ],
                                        saving_throw_proficiencies: [ "con", "cha" ])

       @class2 = CharacterClass.create!(name: "Druid",
                                        description: "One with nature",
                                        hit_die: 8,
                                        skill_proficiencies: [ {
                                          "choose" => 2,
                                          "skills" => [ "arcana", "animal handling", "insight", "medicine", "nature", "perception", "religion", "survival" ]

                                        } ],
                                        saving_throw_proficiencies: [ "int", "wis" ])
      @class3 = CharacterClass.create!(name: "Rogue",
                                        description: "SOOOO sneaky",
                                        hit_die: 8,
                                        skill_proficiencies: [ {
                                          "choose" => 4,
                                          "skills" => [ "acrobatics", "athletics", "deception", "insight", "intimdation", "investigation", "perception", "performance", "persuasion", "sleight of hand", "stealth" ]

                                        } ],
                                        saving_throw_proficiencies: [ "dex", "int" ])

      @target_id = @class2.id
    end

    describe "GET /api/v1/character_classes" do
      it "should retrieve all character classes" do
        get "/api/v1/character_classes"

        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)

        character_classes = json[:data]
        expect(character_classes.count).to eq(3)

        first_class = character_classes.first
        last_class = character_classes.last

        # require "pry"; binding.pry

        expect(first_class[:id]).to eq(@class1.id)
        expect(first_class[:attributes][:name]).to eq(@class1.name)
        expect(first_class[:attributes][:description]).to eq(@class1.description)
        expect(first_class[:attributes][:hit_die]).to eq(@class1.hit_die)
        expect(first_class[:attributes][:skill_proficiencies].first[:choose]).to eq(@class1.skill_proficiencies.first["choose"])
        expect(first_class[:attributes][:skill_proficiencies].first[:skills]).to eq(@class1.skill_proficiencies.first["skills"])
        expect(first_class[:attributes][:saving_throw_proficiencies]).to eq(@class1.saving_throw_proficiencies)

        expect(last_class[:id]).to eq(@class3.id)
        expect(last_class[:attributes][:name]).to eq(@class3.name)
        expect(last_class[:attributes][:description]).to eq(@class3.description)
        expect(last_class[:attributes][:hit_die]).to eq(@class3.hit_die)
        expect(last_class[:attributes][:skill_proficiencies].first[:choose]).to eq(@class3.skill_proficiencies.first["choose"])
        expect(last_class[:attributes][:skill_proficiencies].first[:skills]).to eq(@class3.skill_proficiencies.first["skills"])
        expect(last_class[:attributes][:saving_throw_proficiencies]).to eq(@class3.saving_throw_proficiencies)
      end
    end

    describe "GET /api/v1/character_classe/{ID}" do
      it "should retrieve one character class" do
        get "/api/v1/character_classes/#{@target_id}"

        expect(response).to be_successful

        json = JSON.parse(response.body, symbolize_names: true)
        target_class = json[:data].first

        expect(target_class[:id]).to eq(@class2.id)
        expect(target_class[:attributes][:name]).to eq(@class2.name)
        expect(target_class[:attributes][:description]).to eq(@class2.description)
        expect(target_class[:attributes][:hit_die]).to eq(@class2.hit_die)
        expect(target_class[:attributes][:skill_proficiencies].first[:choose]).to eq(@class2.skill_proficiencies.first["choose"])
        expect(target_class[:attributes][:skill_proficiencies].first[:skills]).to eq(@class2.skill_proficiencies.first["skills"])
        expect(target_class[:attributes][:saving_throw_proficiencies]).to eq(@class2.saving_throw_proficiencies)
      end
    end
  end
end
