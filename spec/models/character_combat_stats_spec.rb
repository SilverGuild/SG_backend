require 'rails_helper'

RSpec.describe CharacterCombatStats, type: :model do
  let(:password) { "password123" }
  let(:user) { User.create!(username: "user1", email: "user1@gmail.com", password: password) }
  let(:character) do
    Character.create!(name: "Kaelynn Thornwick", level: 5, experience_points: 6500,
                       alignment: "Neutral Good", background: "Hermit", user_id: user.id,
                       character_class_id: "druid", race_id: "gnome",
                       subclass_id: "land", subrace_id: "rock-gnome",
                       languages: [ "common", "gnomish" ])
  end

  subject do
    CharacterCombatStats.new(character: character, current_hp: 30, max_hp: 38, temporary_hp: 0, hit_dice_remaining: 5, death_save_successes: 0, death_save_failures: 0, stable: false, armor_class: 15, conditions: [])
  end

  describe "relationships" do
    it { should belong_to(:character) }
  end

  describe "validations" do
    it { should validate_presence_of(:current_hp) }
    it { should validate_numericality_of(:current_hp).only_integer.is_greater_than_or_equal_to(0) }

    it { should validate_presence_of(:max_hp) }
    it { should validate_numericality_of(:max_hp).only_integer.is_greater_than_or_equal_to(0) }

    it { should validate_numericality_of(:temporary_hp).only_integer.is_greater_than_or_equal_to(0) }

    it { should validate_numericality_of(:death_save_successes).only_integer.is_greater_than_or_equal_to(0).is_less_than_or_equal_to(3) }
    it { should validate_numericality_of(:death_save_failures).only_integer.is_greater_than_or_equal_to(0).is_less_than_or_equal_to(3) }

    it { should validate_presence_of(:armor_class) }
    it { should validate_numericality_of(:armor_class).only_integer.is_greater_than_or_equal_to(0) }

    it "rejects a second combat stats row for the same character" do
      CharacterCombatStats.create!(character: character, current_hp: 30, max_hp: 38, armor_class: 15)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:character_id]).to include("has already been taken")
    end

    it "is invalid when stable is nil" do 
      subject.stable = nil
      expect(subject).not_to be_valid
    end

    it "is valid when stable is true or false" do
      subject.stable = true
      expect(subject).to be_valid
      subject.stable = false
      expect(subject).to be_valid
    end

    it "rejects current_hp greater than max_hp" do
      subject.current_hp = 50
      expect(subject).not_to be_valid
      expect(subject.errors[:current_hp]).to include("can't exceed max hp")
    end

    it "rejects hit_dice_remaining greater than character level" do
      subject.hit_dice_remaining = character.level + 1
      expect(subject).not_be be_valid
      expect(subject.errors[:hit_dice_remaining]).to include("can't exceed character level")
    end

    it "rejects a malformed condition slug" do
      subject.conditions = [ "Poisoned" ]
      expect(subject).not_to be_valid
      expect(subject.errors[:conditions]).to include("contains an invalid condition slug")
    end

    it "accepts valid condtion slugs" do
      subject.conditions = [ "poisoned", "frightened" ]
      expect(subject).to be_valid
    end
  end
end
