require 'rails_helper'

RSpec.describe CharacterSkill, type: :model do
  let(:password) { "password123" }
  let(:user) { User.create!(username: "user1", email: "user1@gmail.com", password: password) }
  let(:character) do
    Character.create!(name: "Kaelynn Thornwick", level: 1, experience_points: 0, alignment: "Neutral Good", background: "Hermit", user_id: user.id, character_class_id: "druid", race_id: "gnome", subclass_id: "land", subrace_id: "rock-gnome", languages: [ "common", "gnomish" ])
  end

  describe "relationships" do
    it { should belong_to(:character) }
  end

  describe "validations" do
    it { should validate_presence_of(:skill_id) }

    it "rejects a duplicate skill_id for the same character" do
      CharacterSkill.create!(character: character, skill_id: "stealth")
      duplicate = CharacterSkill.new(character: character, skill_id: "stealth")

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:skill_id]).to include("has already been taken")
    end

    it "allows the same skill_id across different characters" do
      other_user = User.create!(username: "user2", email: "user2@gmail.com", password: password)
      other_character = Character.create!(name: "Theren Nightblade", level: 5, experience_points: 500, alignment: "Lawful Evil", background: "Aristocrate", user_id: other_user.id, character_class_id: "paladin", race_id: "dragonborn", subclass_id: "devotion", subrace_id: "", languages: [ "common", "draconic" ])

      CharacterSkill.create!(character: character, skill_id: "stealth")
      same_skill = CharacterSkill.new(character: other_character, skill_id: "stealth")

      expect(same_skill).to be_valid
    end
  end

  describe "custom validations" do
    it "rejects expertise without proficiency" do
      skill = CharacterSkill.new(character: character, skill_id: "stealth", proficient: false, expertise: true)
      
      expect(skill).not_to be_valid
      expect(skill.errors[:expertise]).to include("can;t be true without proficiency in the skill")
    end
    
    it "allows expertise when proficient is also true" do
      skill = CharacterSkill.new(character: character, skill_id: "stealth", proficient: true, expertise: true)
      
      expect(skill).to be_valid
    end
    
    it "allows proficiency without expertise" do
      skill = CharacterSkill.new(character: character, skill_id: "stealth", proficient: true, expertise: false)
      
      expect(skill).to be_valid
    end
  end
end
