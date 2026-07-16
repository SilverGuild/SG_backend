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
      
    end

    it "allows the same skill_id across different characters" do
      
    end
  end

  describe "custom validations" do
    it "rejects expertise without proficiency" do
      
    end

    it "allows expertise when proficient is also true" do
      
    end

    it "allows proficiency without expertise" do
      
    end
  end
end
