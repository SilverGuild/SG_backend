require 'rails_helper'

RSpec.describe CharacterAbilityScore, type: :model do
  let(:password) { "password123" }
  let(:user) { User.create!(username: "user1", email: "user1@gmail.com", password: password) }
  let(:character) do
    Character.create!(name: "Kaelynn Thornwick", level: 1, experience_points: 0, alignment: "Neutral Good", background: "Hermit", user_id: user.id, character_class_id: "druid", race_id: "gnome", subclass_id: "land", subrace_id: "rock-gnome", languages: [ "common", "gnomish" ])
  end

  describe "relationships" do
    it { should belong_to(:character) }
  end

  describe "validations" do
    it { should validate_presence_of(:ability_id) }
    it { should validate_presence_of(:score) }
    it { should validate_numericality_of(:score).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(30) }

    it "rejects a duplicate ability_id for the same character" do
      CharacterAbilityScore.create!(character: character, ability_id: "str", score: 14)
      duplicate = CharacterAbilityScore.new(character: character, ability_id: "str", score: 10)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:ability_id]).to include("has already been taken")
    end

    it "allows the same ability_id across different characters" do
        other_user = User.create!(username: "user2", email: "user2@gmail.com", password: password)
        other_character = Character.create!(name: "Theren Nightblade", level: 5, experience_points: 500, alignment: "Lawful Evil", background: "Aristocrate", user_id: other_user.id, character_class_id: "paladin", race_id: "dragonborn", subclass_id: "devotion", subrace_id: "", languages: [ "common", "draconic" ])

        CharacterAbilityScore.create!(character: character, ability_id: "str", score: 14)
        same_ability = CharacterAbilityScore.new(character: other_character, ability_id: "str", score: 16)

        expect(same_ability).to be_valid
    end
  end

  describe "saving_throw_proficient" do
    it "is invalid when nil" do
      score = CharacterAbilityScore.new(character: character, ability_id: "str", score: 14,
                                        saving_throw_proficient: nil)
      expect(score).not_to be_valid
      expect(score.errors[:saving_throw_proficient]).to include("is not included in the list")
    end

    it "is valid when true" do
      score = CharacterAbilityScore.new(character: character, ability_id: "str", score: 14,
                                        saving_throw_proficient: true)
      expect(score).to be_valid
    end

    it "is valid when false" do
      score = CharacterAbilityScore.new(character: character, ability_id: "str", score: 14,
                                        saving_throw_proficient: false)
      expect(score).to be_valid
    end
  end
end
